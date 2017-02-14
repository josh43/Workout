//
//  WorkoutAppTests.swift
//  WorkoutAppTests
//
//  Created by joshua on 2/7/17.
//  Copyright (c) 2017 joshua. All rights reserved.
//

import XCTest
import Alamofire.Swift
import SwiftyJSON.Swift


@testable import WorkoutApp

class WorkoutAppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testModel(){
        let e = expectation(description: "work")
        WorkoutGetter.GetWorkout("FE4528C") { (response ) in
            
            let json = JSON(response.data)
            
          
           
            if let workout =  Workout(fromJson: json){
                workout.printAll()
                e.fulfill()
            }

           
            
        }
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
