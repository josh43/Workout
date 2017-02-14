//
// Created by joshua on 2/7/17.
// Copyright (c) 2017 ___FULLUSERNAME___. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON.Swift

//curl -k https://arcane-anchorage-34204.herokuapp.com/handleCode --data-binary '{"code":"FE4528C"}' -H "Content-Type:application/json" > curl1.out

class WorkoutGetter{
    static let BASE_URL = "https://arcane-anchorage-34204.herokuapp.com/";

    static let defaultManager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "https://arcane-anchorage-34204.herokuapp.com:80": .disableEvaluation

        ]
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
   
    /// Get workout from server
    ///
    /// - Parameters:
    ///   - workout: workout ID
    ///   - completionHandler: completion handler
    class func GetWorkout(_ workout:String,_ completionHandler : @escaping(DataResponse<Any>)->Void){
        let params: Parameters = [
            "code":workout
        ]
        let headers : HTTPHeaders = [
            "Accept":"application/json"
        ]
        
        WorkoutGetter.defaultManager.request(WorkoutGetter.BASE_URL + "handleCode", method: .post, parameters: params,
                        encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: completionHandler)
    }
    
    /// Get image
    ///
    /// - Parameters:
    ///   - imgURL: url
    ///   - _completionHandler: completion handler
    class func GetImage(_ imgURL : String, _completionHandler: @escaping(UIImage?)->Void){
        WorkoutGetter.defaultManager.request(imgURL).responseJSON{
            response in
            guard response.data != nil else{_completionHandler(nil); return;}
            if let data = response.data{
                let img = UIImage(data: data)
                _completionHandler(img);
            }else{
                _completionHandler(nil)
            }
            
            
        }
    }
}
