//
//  ModelUpdateSaveDelete.swift
//  WorkoutApp
//
//  Created by joshua on 2/7/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import XCTest
import Foundation
import SwiftyJSON

class ModelUpdateSaveDelete: XCTestCase {
    
    static func getJSONFrom(_ str : String) -> Data?{
        
        if let path = Bundle.main.path(forResource: str, ofType: "formatted") {

        
            return FileManager.default.contents(atPath: path)
        }else{
            return nil
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
      
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSaveAndLoad() {
        let jsonString = JSON(ModelUpdateSaveDelete.getJSONFrom("curl1"))
        print(jsonString)
        var map: WorkoutMap! = nil
        map = WorkoutMap.Singleton
        map.deleteAll()
        var workout: Workout! = nil
        if (workout = Workout(fromJson: jsonString)) != nil{
            
            map.addWorkout("12304", workout)
        }
        map.saveAll()
        
        
        // Now re load it
        map.reload()
        map = WorkoutMap.Singleton
        map.loadAll()
        map.printAllWorkouts()
        
        
        XCTAssert(Workout.compareWorkouts(workout,map.map["12304"]!),"Dictionaries do not match")
        // check that the saved ouput string matches the original jsonString
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testChangeValues(){
        // create workout
        let jsonString = JSON(ModelUpdateSaveDelete.getJSONFrom("curl2")!)
        let e = expectation(description:"Dummy expecation")
        
        print(jsonString)
        var map: WorkoutMap! = WorkoutMap.Singleton
        map.deleteAll()
        
        var workout: Workout! = nil
        if (workout = Workout(fromJson: jsonString)) != nil{
            XCTAssert(map.addWorkout("12304", workout))
        }
        map.saveAll()
        
        // change it
        if let exercise = map.map["12304"]?.exerciseList[0]{
            XCTAssert( exercise.setNumberOfReps(100),"Failed to set number of reps");
            XCTAssert( exercise.setNumberOfSets(55),"Failed to set number of sets");
            XCTAssert( exercise.setDuration(45),"Failed to set duration");
            
         
           
        }
        // save workout
        map.saveAll()

        
        // Now re load it
        map.reload()
        map = WorkoutMap.Singleton
        map.loadAll()
        map.printAllWorkouts()
        
        
        XCTAssert(Workout.compareWorkouts(workout,map.map["12304"]!),"Dictionaries do not match")
        waitForExpectations(timeout: 100000000, handler: nil)
        
        // TODO simple update changes...
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
