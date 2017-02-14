//
//  HomeVC.swift
//  WorkoutApp
//
//  Created by joshua on 2/8/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class HomeVC: UIViewController {
    
    @IBOutlet weak var gotoWorkoutButton: UIButton!
    @IBOutlet weak var findCodeButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        findCodeButton.layer.cornerRadius = 9.0
        gotoWorkoutButton.layer.cornerRadius = 9.0
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorMessage(_ tit : String = "Unable to find workout code",
                     _ mess : String = "Please enter another one"){
        
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { (x : UIAlertAction) in
            // user pressed done
            
        }
        
        
        alert.addAction(defaultAction)
        self.present(alert, animated: true,completion: nil)
    }
    
    @IBAction func tappedFindCode(_ sender: Any) {
        guard textField.text != nil else{
            return
        }
        
        
        WorkoutGetter.GetWorkout(textField.text!) { [weak self](response : DataResponse<Any>) in
            
            guard response.error == nil else{
                self?.errorMessage("Bad response","Try again later")
                return
            }
            
            
            let json = JSON(response.data)
            let workout = Workout(fromJson: json)
            // now do main queue because you can only update table view data(by tableView.reloadData(), change views etc from the main view
            
            guard workout != nil else{
                self?.errorMessage("Our server is having a hickup","try again later")
                return
            }
            if WorkoutMap.Singleton.addWorkout((self?.textField.text!)!, workout!) == false{
                self?.errorMessage("You already have this workout!","")
            }
            
            DispatchQueue.main.async {[weak self] in
                
                    self?.textField.text = ""
                    if(workout != nil){
                        self?.performSegue(withIdentifier: "showWorkoutSegue", sender: self)
                        // else now present
                    }else{
                        self?.errorMessage()
                    }
                
            }
            
        }
        
    }
   
    
    @IBAction func tappedWorkoutList(_ sender: Any) {
        // automatically transitions to workout list
        print("tapped workout list")
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
