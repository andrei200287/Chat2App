//
//  BoolFromInt.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation

@propertyWrapper
struct BoolFromInt: Codable {
    var wrappedValue: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let intValue = try container.decode(Int.self)
        switch intValue {
        case 0: wrappedValue = false
        case 1: wrappedValue = true
        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected `0` or `1` but received `\(intValue)`")
        }
    }
}
