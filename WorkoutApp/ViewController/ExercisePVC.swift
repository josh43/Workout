//
//  ExercisePVC.swift
//  WorkoutApp
//
//  Created by joshua on 2/8/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import UIKit

/// PageViewController used to display the exercises within a workout
class ExercisePVC: UIPageViewController , UIPageViewControllerDataSource {

    @IBOutlet weak var navItem: UINavigationItem!
    let pageId = "PageVC"
    var  workoutIndex : Int! = nil
    var exerciseIndex : Int! = nil
    var vcList :[UIViewController]! = nil
    var finishList :[Bool]! = nil
    var imageCache :[UIImage?]! = nil
    
    
    /// NSCoder initializer, never call this method from code
    ///
    /// - Parameter aDecoder: NSCoder
    required init(coder aDecoder :NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// Sets up image cache
    ///
    /// - Parameter workout: workout for which we will setup image ache
    func setupCache(_ workout : Workout){
        
        for i in 0..<workout.exerciseList.count{
            if let url = workout.exerciseList[i].getImageURL() {
                let index = i
                WorkoutGetter.GetImage(url){[weak self,index] img in
                    self?.imageCache[index] = img
                    if let toNotify = self?.vcList[index] as? WorkoutPage {
                        toNotify.didDownloadPicture(index)
                    }
                }
            
            // configure pages
            }
        }
        
    }

    
    /// Called when user has finished his exercise, keeps
    /// track of current exercise and when all are complete displays a popup to congratulate user
    func finishedWorkout(){
        finishList[exerciseIndex] = true
        for fin in finishList{
            if(!fin){
                return
            }
            
        }
       
        // else success present a nice popover message!
        let workout = WorkoutMap.Singleton.mapList[workoutIndex].1
         finishList = Array<Bool>(repeating: false, count:workout.exerciseList.count)
        
        let alert = UIAlertController(title: "Good job!", message: "You finished todays workout!", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { (x : UIAlertAction) in
            // user pressed done
            
        }
        
        alert.addAction(defaultAction)
        self.present(alert, animated: true,completion: nil)
        
    }
  
    
    /// Helper function to actually create the exercise views
    ///
    /// - Parameter workoutIndex: workout index to be loaded
    func loadWorkout(_ workoutIndex: Int){
        
        
        
        
        self.workoutIndex = Int(workoutIndex)
        let workout = WorkoutMap.Singleton.mapList[workoutIndex].1
        navItem.title = WorkoutMap.Singleton.mapList[workoutIndex].0
        
        
        let numImages = workout.exerciseList.count
        imageCache = Array<UIImage>( repeating: UIImage(),count:numImages)
        finishList = Array<Bool>.init(repeating: false, count: workout.exerciseList.count)

        vcList = [UIViewController]()
        for  i in 0..<workout.exerciseList.count{
            let vc = storyboard?.instantiateViewController(withIdentifier: pageId) as! WorkoutPage
            //    func loadExercise(workoutInd wi : Int, exerciseIn ei: Int){
            
            
            vc.loadExercise(workoutInd:workoutIndex,exerciseIn:i,should : true)
            vc.loadViewIfNeeded()
            
            vc.pageController = self;
            vcList.append(vc)
            // configure pages
        }
        // MUST SETUP AFTER
        setupCache(workout)
        exerciseIndex = 0
        setViewControllers([vcList[0]], direction: .forward, animated: true, completion: nil)
    }
   
    // MARK: Navigation between pages functions
    func prevExercise(){
        guard exerciseIndex != nil,
            exerciseIndex > 0 else{
                return
        }
        
        
        
        exerciseIndex = exerciseIndex - 1
        if let list = vcList{
            let vc = list[exerciseIndex]
            self.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
        }
        
    }
    func nextExercise(){
        guard exerciseIndex != nil,
            exerciseIndex <= vcList.count - 2 else{
                return
        }
        
        
        
        exerciseIndex = exerciseIndex + 1
        if let list = vcList{
            let vc = list[exerciseIndex]
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
        
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcList.index(of: viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        if(nextIndex >= vcList.count){
            return nil
        }
        exerciseIndex = nextIndex
        return vcList[nextIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcList.index(of: viewController) else{
                return nil
        }
       
        let prevIndex = viewControllerIndex - 1
        
        if(prevIndex < 0){
            return nil
        }
        exerciseIndex = prevIndex
        return vcList[prevIndex]
    }



}
