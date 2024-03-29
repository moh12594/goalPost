//
//  GoalsVC.swift
//  GoalPost
//
//  Created by Mohamed SADAT on 30/11/2017.
//  Copyright © 2017 Mohamed SADAT. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    
  // Outlets
  @IBOutlet weak var goalsTableView: UITableView!
  var goals: [Goal] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    goalsTableView.delegate = self
    goalsTableView.dataSource = self
    goalsTableView.isHidden = false
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchCoreDataObjects()
    goalsTableView.reloadData()
  }
  
  func fetchCoreDataObjects() {
    self.fetch { (complete) in
      if complete {
        if goals.count >= 1 {
          goalsTableView.isHidden = false
        } else {
          goalsTableView.isHidden = true
        }
      }
    }
  }
  @IBAction func addGoalButtonPressed(_ sender: Any) {
    guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else {
      return
    }
    presentDetail(createGoalVC)
  }
  
}

extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return goals.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = goalsTableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else {
      return UITableViewCell()
    }
    let goal = goals[indexPath.row]
    cell.configureCell(goal: goal)
    return cell
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return .none
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .destructive, title: "SUPPRIMER") { (rowAction, indexPath) in
      self.removeGoal(atIndexPath: indexPath)
      self.fetchCoreDataObjects()
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    let addAction = UITableViewRowAction(style: .normal, title: "AJOUTER 1") { (rowAction, indexPath) in
      self.setProgress(atIndexPath: indexPath)
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    addAction.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.662745098, blue: 0.2666666667, alpha: 1)
    return [deleteAction, addAction]
  }
}

extension GoalsVC {
  func setProgress(atIndexPath indexPath: IndexPath) {
    guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
    
    let chosenGoal = goals[indexPath.row]
    
    if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
      chosenGoal.goalProgress = chosenGoal.goalProgress + 1
    } else {
      return
    }
    
    do {
      try managedContext.save()
    } catch {
      debugPrint("Error: \(error.localizedDescription)")
    }
  }
  
  func removeGoal(atIndexPath indexPath: IndexPath) {
    guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
    managedContext.delete(goals[indexPath.row])
    do {
      try managedContext.save()
    } catch {
      debugPrint("Error: \(error.localizedDescription)")
    }
  }
  
  func fetch(completion: (_ complete: Bool) -> ()) {
    guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
    let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
    do {
      goals = try managedContext.fetch(fetchRequest)
      completion(true)
    } catch {
      debugPrint("Error: \(error.localizedDescription)")
    }
  }
}















