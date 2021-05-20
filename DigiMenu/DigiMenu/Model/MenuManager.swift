//
//  MenuManager.swift
//  CookCompanion
//
//  Created by Felix Halim on 15/5/21.
//

import Foundation

//Protocol to use MenuManagerDelegate
protocol MenuManagerDelegate {
    func didUpdateMenu(_ menuManager: MenuManager, meals: MealModel);
    func didFailWithError(error: Error);
}

//API Manager for Menu and Meal Details
struct MenuManager {
    let menuURL = "https://www.themealdb.com/api/json/v1/1";
    
    //Deleagate variable for MenuManager Delegate use
    var delegate: MenuManagerDelegate?
    
    //fetch by name (e.g: Rendang, Pizza etc)
    func fetchByName(_ mealName: String){
        let urlStr = "\(menuURL)/search.php?s=\(mealName)";
        performReq(with: urlStr);
    }
    
    //fetch by id (e.g: 0001, 5431 etc)
    func fetchById(_ mealId: String){
        let urlStr = "\(menuURL)/lookup.php?i=\(mealId)";
        performReq(with: urlStr);
    }
    
    //fetch by random
    func fetchRandom(){
        let urlStr = "\(menuURL)/random.php";
        performReq(with: urlStr);
    }
    
    //fetch by Area (e.g: Mexican, Canadian etc)
    func fetchByArea(_ areaName: String){
        let urlStr = "\(menuURL)/filter.php?a=\(areaName)";
        performReq(with: urlStr);
    }
    
    //fetch by Category (e.g: Seafood, Vegetarian etc)
    func fetchByCategory(_ category: String){
        let urlStr = "\(menuURL)/filter.php?c=\(category)";
        performReq(with: urlStr);
    }
    
    //Perform Request
    func performReq(with urlStr: String){
        //Create URL
        let url = URL(string: urlStr)!
        
        //Create URL Session
        let session = URLSession(configuration: .default);
        
        //Give Session Task
        let task = session.dataTask(with: url) { (data, response, error) in
            //If error than pass error message to delegate
            if error != nil {
                delegate?.didFailWithError(error: error!);
                return
            }
            //If data successful than parse JSON and pass to delagate methods didUpateMenu
            if let safeData = data {
                if let menu = self.parseJSON(safeData) {
                    self.delegate?.didUpdateMenu(self, meals: menu)
                }
            }
        }
        
        //Start Task
        task.resume();
    }
    
    //Decode JSON
    func parseJSON(_ menuData: Data) -> MealModel? {
        //JSON Decoder
        let decoder = JSONDecoder();
        do {
            //Recipe array to keep all recipe response
            var recipeArr: [Recipe] = [];
            //Decoded JSON data
            let decodedData = try decoder.decode(MenuData.self, from: menuData);
            
            //for each meal in the response create a recipe object and append to recipe array
            for meal in decodedData.meals {
                //Append all ingredients into an array
                let ingredients: [String] = [meal.strIngredient1 ?? "",
                                             meal.strIngredient2 ?? "",
                                             meal.strIngredient3 ?? "",
                                             meal.strIngredient4 ?? "",
                                             meal.strIngredient5 ?? "",
                                             meal.strIngredient6 ?? "",
                                             meal.strIngredient7 ?? "",
                                             meal.strIngredient8 ?? "",
                                             meal.strIngredient9 ?? "",
                                             meal.strIngredient10 ?? "",
                                             meal.strIngredient11 ?? "",
                                             meal.strIngredient12 ?? "",
                                             meal.strIngredient13 ?? "",
                                             meal.strIngredient14 ?? "",
                                             meal.strIngredient15 ?? "",
                                             meal.strIngredient16 ?? "",
                                             meal.strIngredient17 ?? "",
                                             meal.strIngredient18 ?? "",
                                             meal.strIngredient19 ?? "",
                                             meal.strIngredient20 ?? "",
                ];
                //Append all ingredient measure into ingMeasure array
                let ingMeasure: [String] = [meal.strMeasure1 ?? "",
                                            meal.strMeasure2 ?? "",
                                            meal.strMeasure3 ?? "",
                                            meal.strMeasure4 ?? "",
                                            meal.strMeasure5 ?? "",
                                            meal.strMeasure6 ?? "",
                                            meal.strMeasure7 ?? "",
                                            meal.strMeasure8 ?? "",
                                            meal.strMeasure9 ?? "",
                                            meal.strMeasure10 ?? "",
                                            meal.strMeasure11 ?? "",
                                            meal.strMeasure12 ?? "",
                                            meal.strMeasure13 ?? "",
                                            meal.strMeasure14 ?? "",
                                            meal.strMeasure15 ?? "",
                                            meal.strMeasure16 ?? "",
                                            meal.strMeasure17 ?? "",
                                            meal.strMeasure18 ?? "",
                                            meal.strMeasure19 ?? "",
                                            meal.strMeasure20 ?? "",
                ];
                //Get all API response
                let id = meal.idMeal;
                let name = meal.strMeal;
                let category = meal.strCategory;
                let area = meal.strArea;
                let instructions = meal.strInstructions;
                let mealImg = meal.strMealThumb ?? "";
                
                //Create Recipe
                let recipe = Recipe(idMeal: id, mealName: name, category: category, area: area, instructions: instructions, mealThumb: mealImg, ingredients: ingredients, ingMeasure: ingMeasure);
                
                //Append to object
                recipeArr.append(recipe);
            }
            
            //Return MealModel type object (with attributes array of recipes)
            let meals = MealModel(meals: recipeArr);
            return meals;
            
        } catch {
            //Catch and print error
            print(error);
            return nil;
        }
    }
}

