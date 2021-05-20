//
//  MealSumModel.swift
//  DigiMenu
//
//  Created by Felix Halim on 17/5/21.
//

import Foundation

//MealSumData model for display usage
struct MealSumModel {
    let meals: [MealHeader];
}

//MealHeader
struct MealHeader {
    let mealName: String;
    let mealImg: String;
    let id: String;
}
