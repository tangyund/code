# -*- coding: utf-8 -*-
"""火山引擎豆包视觉 API 餐品识别（OpenAI 兼容接口）"""
import os
import re
from typing import List, Dict, Any, Optional

from openai import OpenAI

from configs.model_config import ARK_API_KEY, ARK_BASE_URL, DOUBAO_VISION_MODEL

# 限制提示词：输出 食品、重量、热量、蛋白质、碳水；除此之外不输出任何内容
DISH_VISION_PROMPT = """请识别图片中的食品，并**严格按以下格式**输出一行（不要其他解释）：

食品：XXX | 重量：X g | 热量：X kcal | 蛋白质：X g | 碳水：X g

说明：食品写具体名称（如米饭、番茄炒蛋）；重量为预估克数；热量为该重量下的 kcal；蛋白质、碳水单位为克。若某项无法估算则写“未知”。
示例：食品：米饭 | 重量：150 g | 热量：195 kcal | 蛋白质：4 g | 碳水：43 g
"""


def _get_client() -> OpenAI:
    api_key = os.getenv("ARK_API_KEY") or ARK_API_KEY
    if not api_key:
        raise ValueError("请设置环境变量 ARK_API_KEY，配置方法见：https://www.volcengine.com/docs/82379/1399008")
    return OpenAI(
        base_url=os.getenv("ARK_BASE_URL") or ARK_BASE_URL,
        api_key=api_key,
    )


def _parse_number(s: str) -> Optional[str]:
    """从字符串中解析数字，未知或空返回空字符串"""
    if not s or "未知" in s or "未知" in (s or ""):
        return ""
    m = re.search(r"(\d+(?:\.\d+)?)", (s or "").strip())
    return m.group(1) if m else ""


def _parse_dish_lines(text: str) -> List[Dict[str, Any]]:
    """
    从模型返回的文本中解析每行，提取：name(食品), weight, calorie, protein, carb。
    期望格式：食品：XXX | 重量：X g | 热量：X kcal | 蛋白质：X g | 碳水：X g
    """
    if not text or not text.strip():
        return []
    results = []
    for line in text.strip().split("\n"):
        line = line.strip()
        if not line:
            continue
        parts = [p.strip() for p in line.split("|")]
        if not parts:
            continue

        name = ""
        weight = ""
        calorie = fat = carb = protein = ""
        for i, p in enumerate(parts):
            if "食品" in p or (i == 0 and "：" in p and "g" not in p and "kcal" not in p.lower()):
                # 食品：xxx 或首段为名称
                idx = p.find("：") if "：" in p else p.find(":")
                if idx >= 0:
                    name = p[idx + 1:].strip() or name
                elif not name:
                    name = p.strip()
            elif "重量" in p:
                weight = _parse_number(p) or weight
            elif "热量" in p or "kcal" in p.lower():
                calorie = _parse_number(p) or calorie
            elif "脂肪" in p:
                fat = _parse_number(p) or fat
            elif "蛋白质" in p:
                protein = _parse_number(p) or protein
            elif "碳水" in p:
                carb = _parse_number(p) or carb
        # 首段若为纯中文/名称（无数字单位），当作食品名
        if not name and parts and not re.search(r"\d+\s*(g|kcal|克)", parts[0]):
            name = parts[0].strip()
        # 只保留食品名称一行，去掉换行和多余内容
        if name:
            name = name.split("\n")[0].strip()
            if len(name) > 50:
                name = name[:50]
        results.append({
            "name": name,
            "weight": weight,
            "calorie": calorie,
            "fat": fat,
            "carb": carb,
            "protein": protein,
            "probability": "1.0",
        })
    return results


def _fallback_parse_dish_names(text: str) -> List[Dict[str, Any]]:
    """兜底：解析不到结构化信息时，返回空营养字段（保持接口不报错）"""
    if not text or not text.strip():
        return []
    # 不再返回菜名，避免“输出其他内容”的要求被误解；仅返回一条空结构
    return [{
        "name": "",
        "weight": "",
        "calorie": "",
        "fat": "",
        "carb": "",
        "protein": "",
        "probability": "1.0",
    }]


def recognize_dish_by_vision(image_base64: str, top_num: int = 5) -> List[Dict[str, Any]]:
    """
    使用豆包视觉模型识别图片中的餐品及营养信息（热量、脂肪、碳水、蛋白质）。
    返回：[{ "name", "calorie", "fat", "carb", "protein", "probability" }, ...]
    """
    client = _get_client()
    image_url = f"data:image/jpeg;base64,{image_base64}"

    response = client.responses.create(
        model=DOUBAO_VISION_MODEL,
        input=[
            {
                "role": "user",
                "content": [
                    {"type": "input_image", "image_url": image_url},
                    {"type": "input_text", "text": DISH_VISION_PROMPT},
                ],
            }
        ],
    )

    # 只取符合「食品：...| 热量：...」格式的文本，避免 reasoning/summary 等进入解析
    def _get_text_from_obj(obj):
        if obj is None:
            return ""
        if isinstance(obj, str):
            return obj.strip()
        if hasattr(obj, "text") and obj.text:
            return (obj.text or "").strip()
        if isinstance(obj, dict) and obj.get("text"):
            return (obj.get("text") or "").strip()
        if hasattr(obj, "content"):
            c = obj.content
            if isinstance(c, str):
                return c.strip()
            if isinstance(c, list):
                parts = [_get_text_from_obj(part) for part in c]
                return "\n".join(p for p in parts if p).strip()
        if isinstance(obj, dict) and "content" in obj:
            return _get_text_from_obj(obj["content"])
        return ""

    def _is_format_line(s):
        return s and "食品" in s and "热量" in s and "|" in s

    text = ""
    if hasattr(response, "choices") and response.choices:
        msg = response.choices[0].message if hasattr(response.choices[0], "message") else response.choices[0]
        text = _get_text_from_obj(getattr(msg, "content", None) or (msg.get("content") if isinstance(msg, dict) else None))
    if not _is_format_line(text) and hasattr(response, "output") and response.output:
        out = response.output
        if isinstance(out, list):
            candidates = []
            for item in out:
                item_type = getattr(item, "type", None) or (item.get("type") if isinstance(item, dict) else None)
                if item_type in ("reasoning", "summary_text"):
                    continue
                t = _get_text_from_obj(item)
                if t:
                    candidates.append(t)
            for t in candidates:
                if _is_format_line(t):
                    text = t
                    break
            if not _is_format_line(text) and candidates:
                text = candidates[-1]
        else:
            text = _get_text_from_obj(out)
    if not text:
        text = str(response)

    parsed = _parse_dish_lines(text)
    if not parsed:
        parsed = _fallback_parse_dish_names(text)
    return parsed[: max(1, top_num)]
