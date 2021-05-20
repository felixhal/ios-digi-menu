//
//  IngredientManager.swift
//  DigiMenu
//
//  Created by Felix Halim on 17/5/21.
//

import Foundation

//Protocol for MealSumManagerDelegate
protocol MealSumManagerDelegate {
    func didUpdateMealSum(_ menuManager: MealSumManager, meals: MealSumModel);
    func didFailWithError(error: Error);
}

//MealSumManager to manage API request for meal summaries
struct MealSumManager {
    //Meal URL
    let mealSumURL = "https://www.themealdb.com/api/json/v2/9973533";
    
    //Delegate for MealSumManager usage
    var delegate: MealSumManagerDelegate?
    
    //fetch by Category (e.g: Seafood, Vegetarian etc)
    func fetchByAvIngredients(_ ingredients: String){
        let urlStr = "\(mealSumURL)/filter.php?i=\(ingredients)";
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
            //If fail than pass error message
            if error != nil {
                delegate?.didFailWithError(error: error!);
                return
            }
            //if successful response thna parse JSON and send delegates
            if let safeData = data {
                if let mealSummary = self.parseJSON(safeData) {
                    self.delegate?.didUpdateMealSum(self, meals: mealSummary)
                }
            }
        }
        
        //Start Task
        task.resume();
    }
    
    //Decode JSON
    func parseJSON(_ mealSumData: Data) -> MealSumModel? {
        //JSON decoder
        let decoder = JSONDecoder();
        do {
            //MealSumArr to keep multiple MealHeader (more than one meal in a response)
            var mealSumArr: [MealHeader] = [];
            //Decode JSON data
            let decodedData = try decoder.decode(MealSumData.self, from: mealSumData);
            
            //For each mealSum responded create a mealHead object and append to mealSumArr
            for mealSum in decodedData.meals {
                let id = mealSum.idMeal;
                let mealImg = mealSum.strMealThumb ?? "";
                let name = mealSum.strMeal;
                
                //create mealHead
                let mealHead = MealHeader(mealName: name, mealImg: mealImg, id: id);
                //Append to mealSumArr
                mealSumArr.append(mealHead);
            }
            //Put the mealSumArr as an attribute for creating the mealSums
            let mealSums = MealSumModel(meals: mealSumArr);
            return mealSums;
            
        } catch {
            //print error
            print(error);
            return nil;
        }
    }
}
