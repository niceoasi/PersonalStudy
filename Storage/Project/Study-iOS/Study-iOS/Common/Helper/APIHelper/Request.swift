//
//  Request.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 07/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import Foundation
import UIKit

class Request {
    
    fileprivate static var sessionManager: URLSession {
        let sessionManager = URLSession.shared
        return sessionManager
    }
    
    static func urlRequest(apiRequest: API) -> URLRequest? {
        
        guard let url = URL(string: "\(apiRequest.host)\(apiRequest.path)"),
            let paramData = try? JSONSerialization.data(withJSONObject: apiRequest.parameters, options: [])
            else {
                print("Error: Request - request")
                return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRequest.method.rawValue
        urlRequest.httpBody = paramData
        urlRequest.addValue(apiRequest.defaultHeadersAddValue, forHTTPHeaderField: apiRequest.defaultHeadersAddField)
        urlRequest.setValue(String(paramData.count), forHTTPHeaderField: apiRequest.defaultHeadersSetField)
        
        return urlRequest
    }
    
    static func task(urlRequest: URLRequest, successHandler:  @escaping (Any) -> (Void), failureHandler: @escaping (Error) -> (Void)) {
        let task = sessionManager.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!)
                failureHandler(error!)
                return
            }
            guard let data = data else {
                print("Error: Request - request => Data is empty")
                return
            }
            
            guard let result = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                print("Error: Request - request")
                return
            }
            successHandler(result)
        }
        task.resume()
    }
}
