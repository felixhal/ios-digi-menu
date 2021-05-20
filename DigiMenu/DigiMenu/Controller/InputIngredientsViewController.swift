//
//  SearchByIngViewController.swift
//  DigiMenu
//
//  Created by Felix Halim on 17/5/21.
//

import UIKit

class InputIngredientsViewController: UITableViewController {
    
    var ingredientArr: [String] = [];
    var ingredeintsStr = "";

    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    //MARK - TableView Data Source
    //Set the number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientArr.count;
    }
    
    //Set format of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath);
        cell.textLabel?.text = ingredientArr[indexPath.row];
        return cell;
    }
    
    //MARK - TableView Delegate Methods
    //Checkmark tool to help with ingredient checklist
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(ingredientArr[indexPath.row]);
        
        tableView.deselectRow(at: indexPath, animated: true);
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MealByIngredientsViewController
        destinationVC.avIngredientsReq = ingredeintsStr;
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField();
        
        //Alert tab to add buttons
        let alert = UIAlertController(title: "Add New Ingredient", message: "", preferredStyle: .alert);
        
        //Action for Alert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Add Item Button Pressed Action
            if let ingredient = textField.text {
                if !ingredient.isEmpty {
                    self.ingredientArr.append(ingredient);
                }
            }
            
            //Refresh TableView
            self.tableView.reloadData();
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add an Ingredient";
            textField = alertTextField
            
        }
        
        alert.addAction(action);
        
        present(alert, animated: true, completion: nil);
    }
    
    //MARK - Search
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        ingredeintsStr = "";
        if ingredientArr.isEmpty {
            for (index, ingredient) in self.ingredientArr.enumerated() {
                if index < self.ingredientArr.count - 1{
                    //Concatonate into String with "," in the end
                    self.ingredeintsStr += ",\(ingredient.replacingOccurrences(of: " ", with: "_")),";
                } else {
                    //Concatonate into String without ","
                    self.ingredeintsStr += "\(ingredient.replacingOccurrences(of: " ", with: "_"))";
                }
            }
        } else {
            //Make array into IngredientStr (String)
            for (index, ingredient) in self.ingredientArr.enumerated() {
                if index < self.ingredientArr.count - 1{
                    //Concatonate into String with "," in the end
                    self.ingredeintsStr += "\(ingredient.replacingOccurrences(of: " ", with: "_")),";
                } else {
                    //Concatonate into String without ","
                    self.ingredeintsStr += "\(ingredient.replacingOccurrences(of: " ", with: "_"))";
                }
            }
        }
        
        //Pass in IngredientsArr to the next screen for perfromReq
        self.performSegue(withIdentifier: "goToResultsByAvIngredients", sender: self);
    }
}
