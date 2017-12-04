//
//  CreateGoalVC.swift
//  GoalPost
//
//  Created by Mohamed SADAT on 04/12/2017.
//  Copyright © 2017 Mohamed SADAT. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {

  // Outlets
  @IBOutlet weak var goalTextView: UITextView!
  @IBOutlet weak var shortTermButton: UIButton!
  @IBOutlet weak var longTermButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  
  // Variables
  var goalType: GoalType = .shortTerm
  
  override func viewDidLoad() {
    super.viewDidLoad()
    nextButton.bindToKeyboard()
    shortTermButton.setSelectedColor()
    longTermButton.setDeselectedColor()
    goalTextView.delegate = self 
  }
  
  @IBAction func longTermWasPressed(_ sender: Any) {
    goalType = .longTerm
    longTermButton.setSelectedColor()
    shortTermButton.setDeselectedColor()
  }
  
  @IBAction func shortTermWasPressed(_ sender: Any) {
    goalType = .shortTerm
    shortTermButton.setSelectedColor()
    longTermButton.setDeselectedColor()
  }
  
  @IBAction func nextButtonWasPressed(_ sender: Any) {
    if goalTextView.text != "" && goalTextView.text != "Quel est votre objectif ?" {
      guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "FinishGoalVC") as? FinishGoalVC else {return}
      finishGoalVC.initData(description: goalTextView.text, type: goalType)
      presentingViewController?.presentSecondaryDetail(finishGoalVC)
    }
  }
  
  @IBAction func backButtonWasPressed(_ sender: Any) {
    dismissDetail()
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    goalTextView.text = ""
    goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
  }
}
