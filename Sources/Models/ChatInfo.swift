//
//  ChatInfo.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation

struct ChatInfo: Codable {
    let avatar: String?
    let users: [UserConversation]
    let messages: [MessageConversation]
}
