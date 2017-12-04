//
//  FinishGoalVC.swift
//  GoalPost
//
//  Created by Mohamed SADAT on 04/12/2017.
//  Copyright © 2017 Mohamed SADAT. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController, UITextFieldDelegate {
  
  //Outlets
  @IBOutlet weak var finishGoalButton: UIButton!
  @IBOutlet weak var pointsTextField: UITextField!
  
  // Variables
  var goalDescription: String!
  var goalType: GoalType!
  func initData(description: String, type: GoalType) {
    self.goalDescription = description
    self.goalType = type
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    finishGoalButton.bindToKeyboard()
    pointsTextField.delegate = self
  }

  @IBAction func finishGoalButtonWasPressed(_ sender: Any) {
    if pointsTextField.text != "" {
      self.save(completion: { (complete) in
        if complete {
          dismiss(animated: true, completion: nil)
        }
      })
    }
  }
  
  @IBAction func backButtonWasPressed(_ sender: Any) {
    dismissDetail()
  }
  
  func save(completion: (_ finished: Bool) -> ()) {
    guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
    let goal = Goal(context: managedContext)
    goal.goalDescription = goalDescription
    goal.goalType = goalType.rawValue
    goal.goalCompletionValue = Int32(pointsTextField.text!)!
    goal.goalProgress = Int32(0)
    do {
      try managedContext.save()
      print("OKKKKK")
      completion(true)
    } catch {
      debugPrint("Could not save: \(error.localizedDescription)")
      completion(false)
    }
    
  }
  
}
