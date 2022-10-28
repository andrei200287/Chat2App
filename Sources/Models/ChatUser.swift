//
//  ChatUser.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
    var avatar: String?
}
