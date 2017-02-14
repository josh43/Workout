//
//  WorkoutTVC.swift
//  WorkoutApp
//
//  Created by joshua on 2/8/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import UIKit

/// Main Workout table controller, used to go between workouts
class WorkoutTVC: UITableViewController {
    let cellReuse = "WorkoutCell"
    var lastTouchedCell: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // set title text to white...
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
     

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateWorkoutList()-> Void{
        weak var weakMe = self;
        DispatchQueue.main.async {
            if let weakMe = weakMe{
                weakMe.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutMap.Singleton.mapList.count

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workoutCell = tableView.dequeueReusableCell(withIdentifier: cellReuse, for: indexPath) as! WorkoutCell
        
            workoutCell.workoutID.text = WorkoutMap.Singleton.mapList[indexPath.row].0

        
        
     
        
        
        
        return workoutCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // useless
        lastTouchedCell = indexPath.row
        

    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        var index = 0;
        let source = sender as! WorkoutCell
    
        for(name,_) in WorkoutMap.Singleton.mapList{
            if(source.workoutID.text == name){
                break
            }
            index += 1
            
        }
        let exDest = segue.destination.childViewControllers[0] as! ExercisePVC
        exDest.loadWorkout(index)
        
    }
    
 
    
}
