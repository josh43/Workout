//
// Created by joshua on 2/7/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import SwiftyJSON

// In charge of persistance as well
class WorkoutMap{
    
    let path = "save.out"
    var  map : Dictionary<String,Workout>! = nil
    private var privMapList :[(String,Workout)]! = nil

    static var Singleton : WorkoutMap = WorkoutMap()
    
 
    /// Used to reload the singleton, mainly used for testing
   
    // access .0 and .1 for workout
    var mapList :[(String,Workout)]{
        
        get{
            if(privMapList == nil){
              privMapList = [(String,Workout)]()
                for(str,workout) in map{
                    privMapList.append((str,workout))
                }
            }
            
            return privMapList
        }
        
    }
    func values() -> [[Dictionary<String,JSON>]] {
        
        // 2d array
        var toReturn = [[Dictionary<String,JSON>]]()
        for workout in map.values{
            toReturn.append(workout.values())
            
        }
        return toReturn
    }
    /// Initalizies the singleton
    private init() {
        map = Dictionary<String,Workout>()
        _ = mapList // sets it up
    }
    
    
    // MARK: Utility Functions
  
    
    func reload(){
        WorkoutMap.Singleton = WorkoutMap()
    }
    func printAllWorkouts(){
        for workout in map.values{
            workout.printAll()
            
        }
    }
    func reloadMapList(){privMapList = nil; _  = mapList;}
    
    
    /// Add a workout
    ///
    /// - Parameters:
    ///   - str: string ID
    ///   - workout: the actual workout
    /// - Returns: sucess if it is a unique workout, failure if not
    func addWorkout(_ str : String, _ workout : Workout) -> Bool{
        if(map.index(forKey: str) == nil){
            map[str] = workout
            DispatchQueue.main.async {[weak self] in
                self?.privMapList.append(str,workout)
            }
            
            return true
        }else{
            return false
        }
        // add on main thread
        
        
    }
    func removeWorkout(_ str : String) ->Bool{
        if(map.index(forKey: str) == nil){
            return false
        }else{
            map.removeValue(forKey: str)
            return true
        }
    }
    
    // MARK: Methods for loading and saving data
    func getFilePath(_ str: String = "test") -> String{
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let toAdd = str ?? ""
        let filePath = docDir + "/" + toAdd + path
        return filePath
    }
    func deleteAll() -> Bool{
        do{
            try FileManager.default.removeItem(at: URL(string:self.getFilePath())!)
            return true
        }catch{
            return false
        }
    }
    func saveAll(_ str : String = "test"){
        
        let filePath = getFilePath(str)
        NSKeyedArchiver.archiveRootObject(map, toFile: filePath)
        
    }
    func loadAll(_ str : String = "test"){
        
        
            let filePath = getFilePath(str)
            if let res =  NSKeyedUnarchiver.unarchiveObject(withFile: filePath){
                if let finalRes =  res as? Dictionary<String,Workout>{
                    map = finalRes
                    reloadMapList()
                }else{
                    print("Failed to unarchive ..")
                }
                
            }else{
                print("Failed to unarchive  ..")
            }
        
    }
    
}
