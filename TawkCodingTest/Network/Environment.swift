//
//  Environment.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

enum Environment {
    case development, stagging, QA
    
    private var scheme: String {
        "Https://"
    }
    
    private var domain: String {
        switch self {
        case .development, .stagging, .QA:
            return "api.github.com/"
        }
    }
    
    var baseURL: String {
        scheme + domain
    }
    
    
}

enum EndPoint: String {
    case Users = "users"
}
