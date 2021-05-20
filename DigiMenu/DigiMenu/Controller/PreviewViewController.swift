//
//  PreviewViewController.swift
//  DigiMenu
//
//  Created by Felix Halim on 19/5/21.
//

import UIKit

class PreviewViewController: UIViewController {
    
    var currentMeal : Recipe? = nil;
    var menuManager = MenuManager()
    var mealId: String = "";
    var instructions = "";
    var imgURL = "";
    var ingredientsArr: [String] = [];
    var ingMeasureArr: [String] = [];
    
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var CookButton: UIBarButtonItem!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealCategory: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self;
        menuManager.delegate = self;
        CookButton.isEnabled = false;
        menuManager.fetchById(mealId);
        mealName.text = "Orange";
    }
    
    @IBAction func cookPressed(_ sender: Any) {
        //Perform segue to Cooking Steps
        self.performSegue(withIdentifier: "goToSteps", sender: self);
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue way to send instructions
        let destinationVC = segue.destination as! CookingStepsViewController;
        destinationVC.recipeInstruction = instructions;
    }
    
}

extension PreviewViewController: MenuManagerDelegate {
    func didUpdateMenu(_ menuManager: MenuManager, meals: MealModel) {
        DispatchQueue.main.async {
            
            //Output meal
            for ingredient in meals.meals[0].ingredients {
                if ingredient.isEmpty || ingredient == " " {
                } else {
                    self.ingredientsArr.append(ingredient);
                }
            }
            
            for measure in meals.meals[0].ingMeasure {
                if measure.isEmpty || measure == " "{
                } else {
                    self.ingMeasureArr.append(measure);
                }
            }
            
            //Assign the instructions
            self.instructions = meals.meals[0].instructions;
            self.mealName.text = meals.meals[0].mealName;
            self.mealCategory.text = meals.meals[0].category;
            self.imgURL = meals.meals[0].mealThumb;
            self.mealImage.load(url: URL(string: self.imgURL)!);
            
            //refresh tableView Data
            self.tableView.reloadData();
            //Enable CookButton
            self.CookButton.isEnabled = true;
        }
    }
    
    //Display Error
    func didFailWithError(error: Error) {
        print(error);
    }
}

//Mark UITableViewDataSource
extension PreviewViewController: UITableViewDataSource {
    //Set the number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArr.count;
    }
    
    //Set the format of the protoype cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsPreviewCell", for: indexPath);
        cell.textLabel?.text = "\(ingredientsArr[indexPath.row])";
        return cell;
    }
}
