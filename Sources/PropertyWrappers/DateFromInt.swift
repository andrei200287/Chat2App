//
//  DateFromInt.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation

@propertyWrapper
struct DateFromInt: Codable {
    var wrappedValue: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try container.decode(Int.self)
        
        let date: Date = Date(timeIntervalSince1970: Double(intValue))
        wrappedValue = date

    }
}
