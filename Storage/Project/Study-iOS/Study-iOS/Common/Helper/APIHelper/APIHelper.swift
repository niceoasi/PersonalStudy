//
//  APIHelper.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 07/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import Foundation

class APIHelper {
    
    enum response {
        case success(jsonResponse: [[String: Any]])
        case failure(error: Error)
    }
    
    static func request(apiRequest: API, responseHandler: @escaping (response) -> ()) {
        guard let urlRequest = Request.urlRequest(apiRequest: apiRequest) else {
            print("Error: APIManager - request, urlRequest")
            return
        }
        
        Request.task(urlRequest: urlRequest, successHandler: { result in
            guard let result = result as? [[String: Any]] else {
                print("Error: APIManager - request, request")
                return
            }
            responseHandler(response.success(jsonResponse: result))
        }, failureHandler: { error in
            responseHandler(response.failure(error: error))
        })
    }
}
