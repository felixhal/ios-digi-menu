//
//  MenuChoose.swift
//  DigiMenu
//
//  Created by mac on 2021/05/14.
//

import UIKit

class BrowseViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealCategory: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CookButton: UIButton!
    
    //meal image URL (provided by API)
    var imgURL = ""
    
    //Load MenuManager to handle API request
    var menuManager = MenuManager();
    var ingredientsArr: [String] = [];
    var ingMeasureArr: [String] = [];
    public static var currentMeal : Recipe? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self;
        menuManager.delegate = self;
        searchTextField.delegate = self;
        CookButton.isHidden = true
    }
    
    @IBAction func randomPressed(_ sender: UIButton) {
        menuManager.fetchRandom();
    }
}

//MARK: - UITextFieldDelegate
extension BrowseViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //make keyboard dissapear when searchPressed is pressed
        searchTextField.endEditing(true);
        print(searchTextField.text!)
    }
    
    //Option #2: get SearchTextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //make keyboard dissapear when return key is pressed
        searchTextField.endEditing(true);
        return true;
    }
    
    //Notifies when searchTextField.endEditing(true) is executed
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Use searchTextField.text to get mealName
        if let mealName = searchTextField.text {
            menuManager.fetchByName(mealName.replacingOccurrences(of: " ", with: "_"));
        }
        //Empties out textfield after user finish editing
        searchTextField.text = "";
    }
    
    //Notifies when user wants to end editing and validate input
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true;
        } else {
            textField.placeholder = "Type A Meal Name"
            return false;
        }
    }
}

//MARK - MealManagerDelegate
extension BrowseViewController: MenuManagerDelegate {
    func didUpdateMenu(_ menuManager: MenuManager, meals: MealModel){
        DispatchQueue.main.async {
            self.ingredientsArr.removeAll();
            self.ingMeasureArr.removeAll();
            
            //Current Meal Displayed
            BrowseViewController.currentMeal = meals.meals[0];
            //If meal fails
            if meals.meals.isEmpty {
                self.mealName.text = "No Results Found";
                self.mealCategory.text = "Try Again"
            } else {
                //for each ingredient in meals put it in ingredient array
                for ingredient in meals.meals[0].ingredients {
                    if ingredient.isEmpty || ingredient == " " {
                    } else {
                        self.ingredientsArr.append(ingredient);
                    }
                }
                
                //for each ingredient measure in meals put the in ingMeasure array
                for measure in meals.meals[0].ingMeasure {
                    if measure.isEmpty || measure == " "{
                    } else {
                        self.ingMeasureArr.append(measure);
                    }
                }
                
                //Set all atrributes of meals to respective outlets
                self.mealName.text = meals.meals[0].mealName;
                self.mealCategory.text = meals.meals[0].category;
                self.imgURL = meals.meals[0].mealThumb;
                self.mealImage.load(url: URL(string: self.imgURL)!);
                
                //refresh tableView Data
                self.tableView.reloadData()
                self.CookButton.isHidden = false
            }
        }
    }
    
    //Print Error if there is any
    func didFailWithError(error: Error) {
        print(error);
    }
}

//MARK - UIImageView
//UIImageView extention to enable remote pictures
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

//Mark UITableViewDataSource
extension BrowseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath);
        cell.textLabel?.text = "\(ingredientsArr[indexPath.row])";
        return cell;
    }
}
