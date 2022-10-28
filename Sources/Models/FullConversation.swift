//
//  FullConversation.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation

struct FullConversation: Codable {
    let users: [UserConversation]
    let messages: [MessageConversation]
}

struct UserConversation: Codable {
    let userId: String
    let avatar: String?
    let name: String
}

struct MessageConversation: Codable {
    let messageId: Int
    let type: Int
    @DateFromInt var sentDate: Date
    let text: String
    let userId: String
    @BoolFromInt var isRead: Bool
}
