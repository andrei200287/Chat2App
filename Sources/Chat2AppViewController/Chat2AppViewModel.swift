//
//  Chat2AppViewModel.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import MessageKit
import Combine

class Chat2AppViewModel {
    
    internal init(chat2AppService: Chat2AppNetworkServiceable, chatUserName: String, chatUserId: String) {
        self.chat2AppService = chat2AppService
        self.chatUserName = chatUserName
        self.chatUserId = chatUserId
    }
    
    var chat2AppService: Chat2AppNetworkServiceable
    var chatUserName: String
    var chatUserId: String
    @Published var chatInfo: ChatInfo?{
        didSet {
            if let fullConversation = chatInfo {
                let firstUser = fullConversation.users[0];
                let secondUser = fullConversation.users[1];
                self.user = ChatUser(senderId: firstUser.userId, displayName: firstUser.name)
                self.user2 = ChatUser(senderId: secondUser.userId, displayName: secondUser.name)
                self.messageList = []
                for message in fullConversation.messages {
                    if message.type == 2 {
                        let chatMessage = ChatMessage(imageURL: message.text, user: userBy(senderId: message.userId), messageId: "\(message.messageId)", date: message.sentDate)
                        messageList.append(chatMessage)
                    } else {
                        let chatMessage = ChatMessage(text: message.text, user: userBy(senderId: message.userId), messageId: "\(message.messageId)", date: message.sentDate)
                        messageList.append(chatMessage)
                    }
                }
            }
        }
    }
    
    func loadChatInfo(completion: @escaping () -> Void){
        Task(priority: .high) { [weak self] in
            guard let self = self else {return}
            let result = await chat2AppService.chatInfo(text: nil, firstMessageText: Chat2App.shared
                .firstMessageText)
            switch result {
            case .success(let chatInfo):
                self.chatInfo = chatInfo
                break
            case .failure(_):
                break
            }
            completion()
        }
    }
    
    func sendUserData(){
        guard let userData = Chat2App.shared.userData else { return }
        Task(priority: .high) {
            _ = await Chat2App.shared.sendUserData(userData: userData)
        }
    }
    
    var lastMessageId: Int {
        guard let chatInfo = self.chatInfo else {
            return 0
        }
        let lastMessageId = chatInfo.messages.last?.messageId ?? 0
        return lastMessageId
    }
    
    func shouldUpdate() async -> Bool {
        guard let _ = self.chatInfo else {
            return false
        }
        let result = await chat2AppService.lastMessageId()
        switch result {
        case .success(let lastMessageId):
            if lastMessageId.lastMessageId != self.lastMessageId {
                return true
            }
            return false
        case .failure(_):
            return false
        }
    }
    
    func sendMessage(text: String, completion: @escaping () -> Void){
        Task(priority: .high) { [weak self] in
            guard let self = self else {return}
            let result = await chat2AppService.chatInfo(text: text, firstMessageText: nil)
            switch result {
            case .success(let chatInfo):
                self.chatInfo = chatInfo
                break
            case .failure(_):
                break
            }
            completion()
        }
    }
    
    func sendImage(text: String?, imageData: Data, completion: @escaping () -> Void){
        Task(priority: .high) { [weak self] in
            guard let self = self else {return}
            let result = await chat2AppService.sendImage(text: text, imageData: imageData)
            switch result {
            case .success(let chatInfo):
                self.chatInfo = chatInfo
                break
            case .failure(_):
                break
            }
            completion()
        }
    }
    
    var user: ChatUser = ChatUser(senderId: "1", displayName: "")
    var user2: ChatUser = ChatUser(senderId: "2", displayName: "")
    
    func userBy(senderId:String) -> ChatUser {
        if senderId == user.senderId {
            return user
        } else {
            return user2
        }
    }
                                
    lazy var messageList: [ChatMessage] = []
}
