//
//  API.swift
//  onTheMap
//
//  Created by Nada AlAmri on 03/05/1440 AH.
//  Copyright © 1440 udacity. All rights reserved.
//

import Foundation
class API{
    
    static var uniqueKey = ""
    static var first_name = ""
    static var last_name = ""
    
    
    static  func login (userEmail: String, password: String, completion: @escaping (Bool, String, Error?)->()) {
        //making request
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //check error
            guard (error == nil) else {
                completion (false, "", error)
                
                return
            }
            
            //check status
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                
                completion (false, "", statusCodeError)
                return
            }
            
            if(statusCode >= 200 && statusCode <= 299  )
            {
                
                let range = Range(5..<data!.count)
                let newData = data?.subdata(in: range)
                let loginJsonObject = try! JSONSerialization.jsonObject(with: newData!, options: [])
                let loginDictionary = loginJsonObject as? [String : Any]
                let accountDictionary = loginDictionary? ["account"] as? [String : Any]
                uniqueKey = accountDictionary? ["key"] as? String ?? " "
                
                completion (true, uniqueKey, nil)
            } else {
                
                completion (false, "", nil)
            }
        }
        task.resume()
        
    }
    static func getLocations (completion: @escaping ([StudentInformation]?, Error?) -> ()) {
        var request = URLRequest (url: URL (string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                completion (nil, error)
                return
            }
            guard let data = data else{
                return
            }
            
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                do
                {
                    
                    
                    let jsonObject = try! JSONSerialization.jsonObject(with: data, options: [])
                    
                    guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                    let resultsArray = jsonDictionary["results"] as? [[String:Any]]
                    
                    guard let JsonArray = resultsArray else {return}
                    let dataObject = try! JSONSerialization.data(withJSONObject: JsonArray, options: .prettyPrinted)
                    let studentsLocations = try JSONDecoder().decode([StudentInformation].self, from: dataObject)
                    completion (studentsLocations, nil)
                    
                    
                }catch let error
                {
                    completion (nil, error)
                    
                }
            }
        }
        
        task.resume()
    }
    
    
    static func deleteSession()
    {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
        }
        task.resume()
    }
    
    static func getStudentInfo(completion: @escaping (Bool, String, String,  Error?)->()) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/user_id=\(uniqueKey)")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                  completion (false, "", "",  error)
                return
            }
            guard let data = data else{
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion (false,"", "", statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                
                let jsonObject = try! JSONSerialization.jsonObject(with: newData, options: [])
                let dataDictionary = jsonObject as? [String : Any]
                first_name = dataDictionary? ["first_name"] as? String ?? " "
                last_name = dataDictionary? ["last_name"] as? String ?? " "
               completion (true,first_name, last_name,  nil)
            }
        }
        
        task.resume()
        
    }
    static func saveLocation( firstName: String, lastName :String, mapString: String, mediaURL: String, lat: Double, long: Double, completion: @escaping (Bool, Error?)->()) {
        var request = URLRequest (url: URL (string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.httpMethod = "post"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\", \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\":\(lat), \"longitude\": \(long)}".data(using: .utf8)
    //    print(long)
    //    print(firstName)
      let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                completion (false, error)
                return
            }
            
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion (false, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                completion(true, nil)
            }
            
            
        }
        task.resume()
    }
    
}

