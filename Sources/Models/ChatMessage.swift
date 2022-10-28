//
//  ChatMessage.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import MessageKit

internal struct ChatMessage: MessageType {
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
    var user: ChatUser
    var sender: SenderType {
      user
    }
    
    private init(kind: MessageKind, user: ChatUser, messageId: String, date: Date) {
      self.kind = kind
      self.user = user
      self.messageId = messageId
      self.sentDate = date
    }
    
    init(text: String, user: ChatUser, messageId: String, date: Date) {
      self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }
    
    init(imageURL: String, user: ChatUser, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(imageURL: URL(string: imageURL)!)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }
}
