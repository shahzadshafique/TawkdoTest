//
//  NetworkHandler.swift
//  TawkCodingTest
//
//  Created by shahzadshafique on 28/10/2022.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol NetworkHandler {
    associatedtype Response
    var headers: [String : String] { get }
    func makeRequest() -> URLRequest?
    func parseResponse(data: Data,
                       response: HTTPURLResponse,
                       request: URLRequest) throws -> Response
}

extension NetworkHandler where Response: Decodable  {
    func parseResponse(data: Data,
                       response: HTTPURLResponse,
                       request: URLRequest) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
    
    var headers: [String : String] {
        ["Authorization":"Bearer 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",
         "Accept": "application/vnd.github+json"]
    }
}
