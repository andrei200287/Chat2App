//
//  File.swift
//  
//
//  Created by Andrei Solovjev on 17/01/2023.
//

import Foundation

public enum AccountStatus: String, Codable {
    case unknownError, wrongParams, userNotFound, active, noSubscription
}

struct AccountStatusModel: Codable {
    let status: AccountStatus
}
