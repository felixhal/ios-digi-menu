//
//  MealModel.swift
//  CookCompanion
//
//  Created by Felix Halim on 15/5/21.
//

import Foundation

import Foundation

//Meal Model
struct MealModel {
    let meals: [Recipe];
}

//Recipe Model
struct Recipe {
    let idMeal: String;
    let mealName: String;
    let category: String;
    let area: String;
    let instructions: String;
    let mealThumb: String;
    var ingredients: [String];
    var ingMeasure: [String];
}
