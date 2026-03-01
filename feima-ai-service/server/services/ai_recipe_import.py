# -*- coding: utf-8 -*-
"""食谱写入 MySQL（与 Java 共用表结构）"""
from typing import Optional
from datetime import datetime

from server.services.ai_result_parser import AIRecipeData, MealData, FoodItem
from server.db.repository.recipe_repository import (
    create_recipe,
    create_meal,
    create_food,
)


async def import_recipe(
    recipe_data: AIRecipeData,
    user_id: int,
    recipe_source_type: str = "AI_PLAN_RECIPE",
) -> Optional[int]:
    """将解析后的食谱导入数据库"""
    if not recipe_data.meals:
        return None

    recipe_name = recipe_data.recipe_name or f"{datetime.now().strftime('%Y-%m-%d')} ai生成食谱"
    recipe_id = await create_recipe(
        recipe_name=recipe_name,
        recipe_desc=recipe_data.recipe_desc,
        user_id=user_id,
        source_type=recipe_source_type,
    )
    if not recipe_id:
        return None

    for meal in recipe_data.meals:
        meal_id = await create_meal(
            recipe_id=recipe_id,
            day_number=meal.day_number,
            meal_type=meal.meal_type,
        )
        if meal_id:
            for food in meal.foods:
                await create_food(
                    meal_id=meal_id,
                    food_name=food.name,
                    amount=food.amount,
                    weight=food.weight,
                    calorie=food.calorie,
                    protein=food.protein,
                    fat=food.fat,
                    carb=food.carb,
                )

    return recipe_id
