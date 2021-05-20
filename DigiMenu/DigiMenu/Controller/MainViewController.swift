//
//  DigiMenuMain.swift
//  DigiMenu
//
//  Created by mac on 2021/05/14.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
    }
    @IBOutlet weak var TextLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var RecipeSearchButton: UIButton!
    @IBOutlet weak var IngredientSearchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleAnimation()
    }
    
    //Animate title label
    func titleAnimation () {
        titleLabel.text = "";
        var charIndex = 0.0;
        let titleText = "🍳DigiMenu";
        //Incrase the time interval between characters
        for char in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(char);
            }
            charIndex += 1;
        }
    }
}
