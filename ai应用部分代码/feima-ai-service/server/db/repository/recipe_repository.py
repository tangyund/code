# -*- coding: utf-8 -*-
"""食谱仓储（调用 Java API）"""
import re
from typing import Optional

from server.db.java_api_client import post


def _parse_weight(weight: str) -> tuple:
    """从 weight 解析 (quantity, unit)。如 '100g' -> (100, '克')"""
    if not weight:
        return 100.0, "克"
    m = re.search(r"(\d+(?:\.\d+)?)\s*(g|克|个|份|片|ml|毫升)?", str(weight).strip(), re.I)
    if m:
        qty = float(m.group(1))
        unit = (m.group(2) or "克").replace("g", "克")
        return qty, unit
    return 100.0, "克"


async def create_recipe(
    recipe_name: str,
    recipe_desc: str,
    user_id: int,
    source_type: str = "AI_PLAN_RECIPE",
) -> Optional[int]:
    """创建食谱主表"""
    try:
        payload = {
            "recipeName": recipe_name,
            "recipeDesc": recipe_desc or "根据用户情况AI生成的个性化计划",
            "recipeSourceType": source_type,
            "userId": user_id,
        }
        data = await post("/api/fasting/recipe", json=payload)
        return data.get("data")
    except Exception:
        return None


async def create_meal(
    recipe_id: int,
    day_number: int,
    meal_type: str,
) -> Optional[int]:
    """创建餐次"""
    try:
        payload = {
            "recipeId": recipe_id,
            "dayNumber": day_number,
            "mealType": meal_type,
            "mealTime": "08:00:00",
        }
        data = await post("/api/fasting/recipe/meal", json=payload)
        return data.get("data")
    except Exception:
        return None


async def create_food(
    meal_id: int,
    food_name: str,
    amount: str,
    weight: str,
    calorie: float,
    protein: float,
    fat: float,
    carb: float,
) -> Optional[int]:
    """创建食品"""
    try:
        qty, unit = _parse_weight(weight)
        payload = {
            "mealId": meal_id,
            "foodType": "SYSTEM_FOOD",
            "foodName": food_name,
            "quantity": qty,
            "unit": unit,
            "calorie": float(calorie or 0),
            "protein": float(protein or 0),
            "fat": float(fat or 0),
            "carbohydrate": float(carb or 0),
        }
        data = await post("/api/fasting/recipe/food", json=payload)
        return data.get("data")
    except Exception:
        return None
