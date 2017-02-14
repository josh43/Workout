//
//  WorkoutPage.swift
//  WorkoutApp
//
//  Created by joshua on 2/9/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import UIKit
import SwiftyJSON

class WorkoutPage: UIViewController , UIPopoverPresentationControllerDelegate{

    var workoutIndex: Int = 0;
    var exerciseIndex: Int = 0;
    var timeLeft : Int? = 0;
    var exercise : Exercise! = nil
    var displayFinish : Bool = false
    weak var pageController : ExercisePVC! = nil
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    
    @IBOutlet weak var backroundImage: UIImageView!
    
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var setListView: UIView!
    var buttonList : [UIButton]! = nil
    

    @IBOutlet weak var finishButton: UIButton!
    
    /// Helper function to actually create the data
    ///
    /// - Parameters:
    ///   - wi: workout index
    ///   - ei: exercise index
    ///   - displayFinishButton: whether or not to display the finish button
    func loadExercise(workoutInd wi : Int, exerciseIn ei: Int, should displayFinishButton : Bool){
        displayFinish = displayFinishButton
        workoutIndex = wi;
        exerciseIndex = ei;
        exercise =  WorkoutMap.Singleton.mapList[workoutIndex].1.exerciseList[exerciseIndex]
     
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard exercise != nil else{return}
        buttonList = Array<UIButton>()
        
        // set basic labels
        self.navigationItem.title = exercise.getTitle()
        if let instructions = exercise.getInstructions(){
            setLabel(repsLabel,instructions,"repeat")
            setLabel(setsLabel,instructions,"complete")
            setLabel(durationLabel,instructions,"hold")
        }
        // transofmr button
        leftButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        setTimeLeft()
        if(displayFinish){
            self.finishButton.isHidden = false
        }else{
            self.finishButton.isHidden = true
        }
        // setup number of sets list
        if let numButtonsString = exercise.getInstructions()?["complete"]?.string{
            let index = numButtonsString.index(numButtonsString.startIndex,offsetBy:1)
            let str = numButtonsString.substring(to: index)
       
            if let numButtons = Int(str){
                setupSetList(numButtons)
            }
            
        }
       
       
        

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Helper function
    func setTimeLeft(){
        timeLeft = exercise.getDuration()
        if(timeLeft == nil){timerLabel.text = ""; timerButton.isHidden = true }
        if timeLeft != nil {timerLabel.text = String(describing: timeLeft!)}
        
    }
    /// Used to setup the set list
    ///
    /// - Parameter numButtons: number of buttons to create
    func setupSetList( _ numButtons : Int){
        if(numButtons <= 0 || numButtons >= 9 ){
            
            return;
        }
        let width = setListView.frame.size.width/5
        var padding = width;
        
        // amount of space in total left for padding
        padding = setListView.frame.width - CGFloat(numButtons) * width
        
        let spaceBetweenButtons = padding / CGFloat(numButtons + 1)
        // can be 1,2 ,3 ,4 buttons
        
        // max of 4 buttons, and padding will be
        setListView.backgroundColor = UIColor.clear
        // there could be 1-4 buttons
        let mainView = self.setListView.frame
        var buttonFrame = CGRect(x: mainView.origin.x + spaceBetweenButtons, y: 0, width: width, height: mainView.height)
        let color = UIColor.clear
        for i in 0..<numButtons{
            // button creation can be complex ...
            let toAdd = UIButton(frame: buttonFrame)
            toAdd.backgroundColor = color
            toAdd.setTitleColor(UIColor.blue, for: .normal)
            toAdd.titleLabel?.textColor = UIColor.blue
            
            toAdd.layer.borderColor = UIColor.blue.cgColor
            toAdd.clipsToBounds = true
            toAdd.layer.borderWidth = 5.0
            toAdd.layer.cornerRadius = 5.0
            
            
            toAdd.setTitle("Set \(i+1)", for: .normal)
            toAdd.alpha = 0.3
            toAdd.addTarget(self, action: #selector(touchedRepButton(_:)), for: .touchUpInside)
            setListView.addSubview(toAdd)
            buttonList.append(toAdd)
            
            
            buttonFrame = buttonFrame.offsetBy(dx: width + spaceBetweenButtons, dy: 0.0)
            
            
        }
        buttonList[0].alpha = 1.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        togglePageButtons(true)
    }
    func togglePageButtons(_ toThis: Bool){
        self.leftButton.isEnabled = toThis
        self.rightButton.isEnabled = toThis
    }
    @IBAction func touchedSettings(_ sender: Any) {
        print("Settings pressed")
    }
    
    /// Notified when a download of the picture has completed
    ///
    /// - Parameter index: index of picture to grab
    func didDownloadPicture(_ index : Int){
            DispatchQueue.main.async {
                [weak self] in
                    if let pvc = self?.pageController{
                        if(pvc.imageCache[index] != nil){
                            self?.backroundImage.image = pvc.imageCache[index]
                        }
                    }
                    
                
                
            }// main thread
    }
    
   
    
    /// Switches to the correct set (NOT REP)
    func touchedRepButton(_ sender : UIButton){
        guard let buttonIndex = buttonList.index(of: sender) else {return;}
        
        guard buttonIndex >= 0,buttonIndex < buttonList.count else{
                return;
        }
        // make all other buttons slightly less visible
        for button in buttonList{
            button.alpha = 0.3;
        }
        
        buttonList[buttonIndex].alpha = 1.0
        
    }

    
    @IBAction func prevExercise(_ sender: Any) {
        // Force a page change, dont allow user to spam it and break it..
        pageController.prevExercise()
      
    }
    
    @IBAction func nextExercise(_ sender: Any) {

        pageController.nextExercise()
       

    }
    @IBAction func didFinishWorkout(_ sender: Any) {
        print("Finished congrats amigo")
        pageController.finishedWorkout()
        finishButton.setTitle("Finished", for: .normal)
        
        
    }
    
   
    func setLabel(_ label : UILabel,_ dict :  Dictionary<String,JSON>,_ str : String){
        label.text = dict[str]?.string
    }
   

    @IBAction func toggleTimer(_ sender: Any) {
        timerButton.isEnabled = false
        timeLeft = self.exercise.getDuration()
        if(timeLeft == nil){
            return
        }
        if(timerButton.titleLabel?.text == "Start Timer"){
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
                self?.timeLeft =  (self?.timeLeft)! - 1
                if((self?.timeLeft)!  <= 0){
                    timer.invalidate()
                    self?.timerButton.isEnabled = true
                    self?.timeLeft = self?.exercise.getDuration()

                }
                DispatchQueue.main.async {
                    self?.timerLabel.text = String(describing: (self?.timeLeft)!);
                    
                    
                }
                
            })
            // resume from last known time if there is one
        }else{
            // pause, save time
            
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
 
    @IBAction func didAskForInfo(_ sender: Any) {
        
        if let popoverViewController = storyboard?.instantiateViewController(withIdentifier: "popoverVC") as? PopoverVCViewController{
            popoverViewController.text = self.exercise.getDescription()
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.popoverPresentationController?.sourceView = infoButton
            popoverViewController.popoverPresentationController?.sourceRect = infoButton.bounds
            self.pageController?.present(popoverViewController, animated: false, completion: nil)
            
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
       
    
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
 
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    

}
