//
//  BKNetworkTool.swift
//  BloomKids
//
//  Created by Andy Tong on 5/19/17.
//  Copyright © 2017 Bloom Technology Inc. All rights reserved.
//

import Foundation
import Alamofire

enum BKNetworkMethod {
    case POST
    case GET
}

class BKNetowrkTool {
    static let shared = BKNetowrkTool()
    
    func request(_ method: HTTPMethod, urlStr: String, parameters: [String: Any],  completion: @escaping (_ success: Bool, _ data: Data?) ->Void ) {
        guard let url = URL(string: urlStr) else{
            print("urlStr error")
            return
        }

        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response: DataResponse) in
            var flag = false
            if let statusCode = response.result.value as? [String: Any] {
                if let code = statusCode["status"] as? Bool {
                    flag = code
                }
            }
            completion(flag, response.data)
            
        }
    }
}


extension BKNetowrkTool {
    func addKid(kidModel: BKKidModel, completion: @escaping (_ sucess: Bool,_ kidid: Int?) -> Void) {
        guard let currentEmail = BKAuthTool.shared.currentEmail else {
            print("currentEmail not complete")
            completion(false, nil)
            return
        }
        
        /*
         var kidName: String
         var id: String
         var gender: String
         var school: String
         var sports: [BKSport]
         var age: Int
        */
        
        var dict = [String: Any]()
        dict["kidname"] = kidModel.kidName
        dict["gender"] = kidModel.gender
        dict["school"] = kidModel.school
        dict["age"] = kidModel.age
        dict["email"] = currentEmail
        print("currentEmail:\(currentEmail)")
        var sportArr = [[String: String]]()
        /*
         var sportName: String
         var interestLevel: String
         var skillLevel: String
        */
        for sport in kidModel.sports {
            var sportDict = [String: String]()
            sportDict["sportname"] = sport.sportName
            sportDict["interestLevel"] = sport.interestLevel
            sportDict["skilllevel"] = sport.skillLevel
            
            sportArr.append(sportDict)
        }
        
        dict["sport"] = sportArr
        
        print("kid info:\(dict)")
        
        request(.post, urlStr: BKNetworkingAddKidUrlStr, parameters: dict) { (success, data) in
            if success {
                do{
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                            let kidid = json["kidid"] as? Int {
                            completion(status, kidid)
                        }
                        
                    }
                } catch {
                    print("Error deserializing JSON: \(error)")
                    completion(false, nil)
                }
                
                
            }else{
                completion(false, nil)
            }
            
            
        }
    }
    
    // If this account haven't added a kid, then the request will be failed
    func getKids(completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        guard let currentEmail = BKAuthTool.shared.currentEmail else {
            print("currentEmail not complete")
            completion(false, nil)
            return
        }
        let dict = ["email": currentEmail]
        request(.post, urlStr: BKNetworkingGetKidUrlStr, parameters: dict) { (success, data) in
            if success {
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                        let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var kids = [BKKidModel]()
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                kids.append(kidModel)
                            }
                            
                            completion(status, kids)
                        }
                        
                    }
                    
                    
                } catch {
                    completion(false, nil)
                }
                
            }else{
                completion(false, nil)
            }
        }
    }
    
    func locationDetails(completion: @escaping (_ success:Bool, _ kids: [BKKidModel]?) -> Void) {
        guard let currentEmail = BKAuthTool.shared.currentEmail,
        let currentState = BKAuthTool.shared.currentState,
        let currentCity = BKAuthTool.shared.currentCity else {
            print("current emial or state or city not complete")
            completion(false, nil)
            return
        }
        let dict = ["email": currentEmail,
                    "city": currentCity,
                    "state": currentState]
        request(.post, urlStr: BKNetworkingLocationDetailsUrlStr, parameters: dict) { (success, data) in
            if success {
                do {
                    if  let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    {
                        if let status = json["status"] as? Bool,
                            let kidsDict = json["kids"] as? [[String: Any]] {
                            
                            var kids = [BKKidModel]()
                            for kidDict in kidsDict {
                                let kidModel = BKKidModel(dict: kidDict)
                                kids.append(kidModel)
                            }
                            
                            completion(status, kids)
                        }
                        
                    }
                    
                    
                } catch {
                    completion(false, nil)
                }
                
            }else{
                completion(false, nil)
            }
        }
    }
}




