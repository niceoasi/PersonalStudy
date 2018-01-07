//
//  TestAPI.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 07/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import Foundation

enum TestAPI: API {
    
    case test(params: [String: String])
    case testOne
    
    var method: HTTPMethod {
        switch self {
        case .test:
            return .get
        case .testOne:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .test:
            return "/getalltrackingdata"
        case .testOne:
            return "/getalltrackingdata"
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .test(let params):
            return params
        case .testOne:
            return [:]
        }
    }
    
    var headersAddValue: String { return defaultHeadersAddValue }
    var headersAddField: String { return defaultHeadersAddField }
    var headersSetField: String { return defaultHeadersSetField }
}
