//
//  APIClient.swift
//  Skylux_iOS_1.1
//
//  Created by James Green on 11/14/17.
//  Copyright © 2017 James Green. All rights reserved.
//

import Foundation

class APIClient{
    var endpoint: String
    var session: URLSession
    var request: URLRequest
    var task: URLSessionDataTask
    var finished: Bool
    var busy: Bool{
        didSet{
            print("API CLIENT BUSY STATUS: \(busy)")
        }
    }
    var completion: (Bool, AnyObject?) {
        didSet{
            print("Finished!")
            if completion.1 != nil{
                finished = true
            }
            print(self.completion)
        }
    }
    
    init(endpointURL endpoint: String){
        self.endpoint = endpoint
        self.session = URLSession(configuration: URLSessionConfiguration.default)
        self.request = URLRequest(url: URL(string: endpoint)!)
        self.completion = (false, nil)
        self.finished = false
        self.busy = false
        self.task = session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                let response = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                print(response as Any)
            }
        }
        task.resume()
    }
    
    private func dataTask(request: URLRequest, method: String, completion: (Bool, AnyObject?)) {
        var request = self.request
        request.httpMethod = method
        
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    print("Good")
                    //completion(true, json as AnyObject)
                    self.completion = (true, json as AnyObject)
                } else {
                    print("Something went wrong")
                    //completion(false, json as AnyObject)
                    self.completion = (false, json  as AnyObject)
                }
            }
            }.resume()
        
        repeat{
            wait()
        } while (self.finished == false)
        busy = false
    }

    
    func post(){
        print("APIClient POST")
        dataTask(request: self.request, method: "POST", completion: self.completion)
        print("APIClient POST END")
    }
    func put(){
        print("APIClient PUT")
        dataTask(request: self.request, method: "PUT", completion: self.completion)
        print("APIClient PUT END")
    }
    func get(){
        print("APIClient GET")
        dataTask(request: self.request, method: "GET", completion: self.completion)
        print("APIClient GET END")
        if((self.completion.1) != nil){
            return
        }
        else{
            wait()
        }
    }
    
    func wait(){
        //empty to just wait
        busy = true
    }
}


