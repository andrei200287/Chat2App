//
//  Endpoint.swift
//  
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var imageBody: Data? { get }
    var getParams: [String: String]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.chat2app.com"
    }
}
