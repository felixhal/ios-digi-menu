//
//  CookingSteps.swift
//  DigiMenu
//
//  Created by mac on 2021/05/14.
//

import UIKit

class CookingStepsViewController: UIViewController {
    
    @IBOutlet weak var StepsLabel: UILabel!
    @IBOutlet weak var StepsNumber: UILabel!
    @IBOutlet weak var StepDescription: UITextView!
    @IBOutlet weak var FinishedButton: UIButton!
    @IBOutlet weak var FryPanImage: UIImageView!
    @IBOutlet weak var ProgressBar: UIProgressView!
    
    
    var steps = 1
    var recipeInstruction : String? = BrowseViewController.currentMeal?.instructions
    var instructionArray : [String] = []
    
    //Button to move to next step
    @IBAction func AfterButton(_ sender: Any) {
        if steps < instructionArray.count-1 {
            steps += 1
            changeDescription()
            let prog = Float(steps) / Float(instructionArray.count)
            ProgressBar.progress = Float(prog)
        }
        else {
            steps += 1
            let prog = Float(steps) / Float(instructionArray.count)
            ProgressBar.progress = Float(prog)
            FinishedButton.isHidden = false
        }
    }
    
    //Button to move to previos step
    @IBAction func BeforeButton(_ sender: Any) {
        if steps > 1 {
            steps -= 1
            changeDescription()
            let prog = Float(steps) / Float(instructionArray.count)
            ProgressBar.progress = Float(prog)
        }
    }
    
    //Collect Instruction and seperate by period
    func SeperateInstruction () {
        instructionArray = recipeInstruction!.components(separatedBy: ".")
        StepDescription.text = instructionArray[0]
    }
    
    //Change instruction text
    func changeDescription () {
        StepsNumber.text = String(steps)
        StepDescription.text = instructionArray[steps]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StepsNumber.text = "1"
        FinishedButton.isHidden = true
        SeperateInstruction()
        ProgressBar.setProgress(0.0, animated: true)
    }
}

