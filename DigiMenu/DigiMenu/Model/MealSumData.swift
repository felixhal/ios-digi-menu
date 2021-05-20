//
//  MealSumData.swift
//  DigiMenu
//
//  Created by Felix Halim on 17/5/21.
//

import Foundation

//MealSumData model (API response model)
struct MealSumData: Codable {
    let meals: [MealSum];
}

//MealSum
struct MealSum: Codable {
    let strMeal: String;
    let strMealThumb: String?;
    let idMeal: String;
}


