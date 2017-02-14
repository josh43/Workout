//
// Created by joshua on 2/7/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Exercise :NSObject, NSCoding{
    /**
     {
      "description": [
         "QUAD SET",
         "Tighten your top thigh muscle as you attempt to press the back of your knee downward towards the table."
      ],
      "instructions": {
         "repeat": "15 Times",
         "hold": "3 Seconds",
         "complete": "2 Sets",
         "perform": "1 Time(s) a Day"
      },
      "img": {
         "src": "https://www.hep2go.com/ex_images/022001-023000/image_022532jpg?pgf=5bfa32c5c14f5c071d395e911cfc66fc",
         "height": "250"
      },
       "video": "javascript: goPlayVideo_0('67705519', 'vimeo');"

   },
    **/
    // MARK: Data
    var data : Dictionary<String, JSON>
    var completed : Bool = false
    
    // MARK : NSCoding
    public func saveProperty(_ prop : String, _ coder : NSCoder){
        do{
            let toSave = try self.data[prop]?.rawData()
            coder.encode(toSave,forKey:prop)
        }catch{
            if(prop == "video"){
                if let toEncode = self.data[prop]?.rawString() {
                    coder.encode(toEncode,forKey:prop)

                }
            }
    
        }
    }
    public func encode(with aCoder: NSCoder) {
        saveProperty("description", aCoder)
        saveProperty("instructions", aCoder)
        saveProperty("img", aCoder)
        saveProperty("video", aCoder)
        
        aCoder.encode(completed, forKey: "completed")
       
        
    }

    public required init?(coder aDecoder: NSCoder) {
        self.data = Dictionary<String,JSON>()
        if let description = aDecoder.decodeObject(forKey: "description"){
            self.data["description"] = JSON(description)
        }
        if let instructions = aDecoder.decodeObject(forKey: "instructions"){
            self.data["instructions"] = JSON(instructions)
        }
        if let img = aDecoder.decodeObject(forKey: "img") {
            self.data["img"] = JSON(img)
        }
        if let video = aDecoder.decodeObject(forKey: "video"){
            self.data["video"] = JSON(video)
            
        }
        
    
        self.completed = aDecoder.decodeBool(forKey: "completed")
        
        
        
       
    }

    /// Initalizer
    ///
    /// - Parameter d: json from server
    init(_ d: Dictionary<String, JSON>) {
        data = d
    }
    
   
    
    //MARK: GETTERS
    func getImageURL()->String?{
        return self.data["img"]?["src"].string
    }
    func getInstructions()->Dictionary<String,JSON>?{
        return self.data["instructions"]?.dictionary
    }
    func getTitle()->String?{
        if(data["description"]?.array == nil){
            return nil
        }
        return  data["description"]?[0].string
         
    }
    func getDescription()->String?{
        
        if(data["description"]?.array == nil){
            return nil
        }
        return  data["description"]?[1].string

    }
    func getDuration() -> Int?{
        
        if let dur = self.data["instructions"]?["hold"].string {
            let extract = "\\b\\d+\\b"
            let nsDurString = dur as NSString
            let regex = try! NSRegularExpression(pattern: extract, options: [])
            let match = regex.matches(in: dur, options: [], range: NSRange(location: 0, length: dur.characters.count))
            let extracted = nsDurString.substring(with: match[0].range)
            return Int(extracted)
        }
        return nil
        
    }
    // MARK: SETTERS
  
    
    func setDuration(_ seconds : Int)->Bool{
        return self.setWorkoutKey("hold", "\(seconds) Seconds")
    }
    func setNumberOfSets(_ numSets : Int)->Bool{
        return self.setWorkoutKey("perform","\(numSets) Time(s) a Day")
    }
    func setNumberOfReps(_ reps : Int)->Bool{
        return self.setWorkoutKey("repeat", "\(reps) Times")
    }
    private func setWorkoutKey(_ str : String, _ newVal : String)->Bool{
        if let _ = self.getDescription(){
            if let _ = self.data["instructions"]?[str].string{
                self.data["instructions"]![str] = JSON(newVal)
                return true
            }else{
                return false
            }
        }else{
            return false;
        }
    }
   
    
}
class Workout : NSObject, NSCoding{

    var exerciseList:[Exercise]! = nil


    //MARK: NSCoding
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(exerciseList,forKey:"list");
    }

    
    public required init?(coder aDecoder: NSCoder) {
        
        if let list = aDecoder.decodeObject(forKey: "list") as? [Exercise]{
                exerciseList = list
        }else{
            return nil
        }
        

    }
    //MARK: Creation from server
 
    init?(fromJson json :JSON){
        
        guard (json.array != nil) else{
            return nil
        }
        exerciseList = Array<Exercise>()
        var createdEx = false
        for (_,subJson):(String, JSON) in json {
            if let d = subJson.dictionary{
               createdEx = true
               exerciseList.append(Exercise(d))
            }else{
                print("Unable to get data")
            }
        }
        if(!createdEx){
            return nil
        }
       
    }
    
    // MARK: Helper Methods for Tests
 
 
    /// Gets the list of exercises
    ///
    /// - Returns: list of exercises
    func values()->[Dictionary<String,JSON>]{
        var toReturn : [Dictionary<String,JSON>] = []
        for workout in exerciseList{
            let toAppend = workout.data
            toReturn.append(toAppend)
        }
        
        return toReturn
    }
    /// Compares two workouts
    ///
    /// - Parameters:
    ///   - left: Workout
    ///   - right: Workout
    /// - Returns: whether or not the two workouts are equivalent
    static func compareWorkouts( _ left: Workout, _ right: Workout)-> Bool{
        for  exercise in left.exerciseList{
            var found = false;
            for  otherEx in right.exerciseList{
                if(exercise.data == otherEx.data){
                    found = true
                    break;
                }
            }
            if(!found){
                return false
            }
        }
        return true
    }
    
    /// prints all exercises
    func printAll(){
        for workout in exerciseList{
            print("\(workout.data)\n");
        }
    }
}
