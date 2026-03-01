# -*- coding: utf-8 -*-
"""解析 AI 文本为结构化食谱"""
import re
from typing import List, Dict, Any, Optional
from dataclasses import dataclass, field


@dataclass
class FoodItem:
    """食品项"""
    name: str
    amount: str
    weight: str
    calorie: float
    protein: float
    fat: float
    carb: float


@dataclass
class MealData:
    """餐次数据"""
    day_number: int
    meal_type: str  # BREAKFAST, LUNCH, DINNER
    foods: List[FoodItem] = field(default_factory=list)
    total_calorie: float = 0


@dataclass
class AIRecipeData:
    """AI 食谱数据"""
    recipe_name: str = ""
    recipe_desc: str = ""
    meals: List[MealData] = field(default_factory=list)


def _extract_day_section(text: str, day: int) -> str:
    """提取第 N 天的内容区块"""
    pattern = rf"第{day}天[\s\S]*?(?=第{day+1}天|###|$)"
    m = re.search(pattern, text)
    return m.group(0) if m else ""


def _extract_meal(day_section: str, day: int, meal_type: str, keyword: str) -> Optional[MealData]:
    """从区块中提取某餐次"""
    meal_keywords = {"早餐": "BREAKFAST", "午餐": "LUNCH", "晚餐": "DINNER"}
    meal = MealData(day_number=day, meal_type=meal_keywords.get(keyword, meal_type))

    # 匹配食物行：食物名+数量+单位（约...g，约...千卡）
    pattern = r"([^\n]+?)\s*（约(\d+)g.*?约(\d+)千卡.*?蛋白质约([\d.]+)g.*?脂肪约([\d.]+)g.*?碳水约([\d.]+)g）"
    start = day_section.find(keyword)
    if start < 0:
        return None

    end = day_section.find("小计：", start)
    if end < 0:
        end = day_section.find("**", start + 1)
    block = day_section[start:end] if end > 0 else day_section[start:]

    for m in re.finditer(pattern, block):
        food = FoodItem(
            name=m.group(1).strip(),
            amount="",
            weight=m.group(2) + "g",
            calorie=float(m.group(3)),
            protein=float(m.group(4)),
            fat=float(m.group(5)),
            carb=float(m.group(6)),
        )
        meal.foods.append(food)
        meal.total_calorie += food.calorie

    return meal if meal.foods else None


def parse_ai_result(analysis_result: str, custom_days: int = 3) -> AIRecipeData:
    """解析 AI 返回的文本为 AIRecipeData"""
    recipe = AIRecipeData(
        recipe_name=f"ai生成食谱",
        recipe_desc="根据用户情况AI生成的个性化计划",
    )
    meals: List[MealData] = []

    for day in range(1, custom_days + 1):
        day_section = _extract_day_section(analysis_result, day)
        if not day_section:
            continue
        for kw in ["早餐", "午餐", "晚餐"]:
            meal = _extract_meal(day_section, day, kw.upper(), kw)
            if meal:
                meals.append(meal)

    recipe.meals = meals
    return recipe
