//
//  API.swift
//  Study-iOS
//
//  Created by Daeyun Ethan Kim on 07/01/2018.
//  Copyright © 2018 K.D. All rights reserved.
//

import Foundation

protocol API {
    var method: HTTPMethod { get }
    var host: String { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var headersAddValue: String { get }
    var headersAddField: String { get }
    var headersSetField: String { get }
}

extension API {
    var host: String {
        return "http://yunsarea.gq/yun/index.php/maps"
    }
    var defaultHeadersAddValue: String {
        return "application/json"
    }
    var defaultHeadersAddField: String {
        return "Content-Type"
    }
    var defaultHeadersSetField: String {
        return "Content-Length"
    }
}
