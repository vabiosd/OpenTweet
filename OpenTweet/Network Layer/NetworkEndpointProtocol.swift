//
//  EndpointProtocol.swift
//  OpenTweet
//
//  Created by vaibhav singh on 23/11/22.
//  Copyright © 2022 OpenTable, Inc. All rights reserved.
//

import Foundation

/// A generic network endpoint protocol that can be used to build network requests to any possible endpoint!

protocol NetworkEndpointProtocol {
    /// Path to the API endpoint
    var path: String { get }
    
    /// Headers required by the request
    var headers: [String: String] { get}
    
    /// URL Params of the endpoint
    var urlParams: [String :String?] { get }
    
    /// Body params of the request
    var bodyParams: [String: Any] { get }
    
    /// Type of request, possible values are GET, POST, PUT etc
    var requestType: String { get }
    
}

extension NetworkEndpointProtocol {
    
    /// Adding default values to the above property requirements
    /// We will just need to define the properties the URL request needs, we can skip the rest!
    
    /// Place the host URL string here!
    var host: String {
        return ""
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var urlParams: [String :String?] {
        return [:]
    }
    
    var bodyParams: [String: Any] {
        return [:]
    }
    
    var requestType: String {
        return "GET"
    }
    
    /// Building up a network request with all available properties!
    func getNetworkRequest() -> URLRequest? {
        var comps = URLComponents()
        comps.scheme = "https"
        comps.host = host
        comps.path = path
        comps.queryItems = urlParams.map{ URLQueryItem(name: $0, value: $1) }
        
        guard let url = comps.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType
        
        if !headers.isEmpty {
            request.allHTTPHeaderFields = headers
        }
            
        if !bodyParams.isEmpty, let bodyData = try? JSONSerialization.data(withJSONObject: bodyParams) {
            request.httpBody = bodyData
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
