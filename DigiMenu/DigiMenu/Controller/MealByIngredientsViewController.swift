//
//  MealSumResultsTableViewController.swift
//  DigiMenu
//
//  Created by Felix Halim on 17/5/21.
//

import UIKit
import SDWebImage

class MealByIngredientsViewController: UITableViewController {
    
    var mealList: [MealHeader] = [];
    var mealImages: [URL] = [];
    var avIngredientsReq = "";
    var mealSumManager = MealSumManager();
    var menuManager = MenuManager();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //Register custom cell ("MealCell") to be used instead of custom cells
        tableView.register(UINib(nibName: "MealCell", bundle: nil), forCellReuseIdentifier: "mealDisplayCell");
        mealSumManager.delegate = self;
        mealSumManager.fetchByAvIngredients(avIngredientsReq);
    }

    // MARK: - Table view data source

    //Set the number of rows in tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealList.count;
    }

    //Set the format and contents of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealDisplayCell", for: indexPath) as! MealCell;
        cell.mealImage.image = nil;
        cell.mealImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.mealImage.sd_imageIndicator = SDWebImageProgressIndicator.`default`
        cell.mealImage.sd_setImage(with: URL(string: mealList[indexPath.row].mealImg)!, completed: nil)
        cell.mealName.text = mealList[indexPath.row].mealName;
        return cell;
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Perform Segue
        self.performSegue(withIdentifier: "goToPreview", sender: self);
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PreviewViewController;
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.mealId = mealList[indexPath.row].id;
        }
    }
}

//Mark: - MealSumManagerDelegate
extension MealByIngredientsViewController: MealSumManagerDelegate {
    func didUpdateMealSum(_ menuManager: MealSumManager, meals: MealSumModel) {
        DispatchQueue.main.async {
            //set all current meals
            self.mealList = meals.meals;
            //reload tableView data
            self.tableView.reloadData();
        }
    }
    
    //Handle Error
    func didFailWithError(error: Error) {
        print(error);
    }
}
