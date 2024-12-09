//
//  Chat2AppNetworkService.swift
//  
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation

protocol Chat2AppNetworkServiceable {
    func chatInfo(text: String?, firstMessageText: String?) async -> Result<ChatInfo, RequestError>
    func sendImage(text: String?, imageData: Data) async -> Result<ChatInfo, RequestError>
    func unreadMessagesCnt() async -> Result<ChatUnreadMessagesCnt, RequestError>
    func lastMessageId() async -> Result<LastMessageId, RequestError>
    func sendUserData(userData: [String: String]) async -> Result<EmptyModel, RequestError>
    func accountStatus() async -> Result<AccountStatusModel, RequestError>
    func addMessageFromOperator(text: String) async -> Result<EmptyModel, RequestError>
    func sendTemplateMessageIfNeeded(templateName: String) async -> Result<Bool, RequestError>
    func checkFriendLinkTapAndSendDiscountIfNeeded() async -> Result<ChatCheckFriendLinkTapAndSendDiscountIfNeededResult, RequestError>
    func logEvent(name: String, value: Chat2App.EventValue) async -> Result<EmptyModel, RequestError>
}

struct Chat2AppNetworkService: HTTPClient, Chat2AppNetworkServiceable {
    
    
    func addMessageFromOperator(text: String) async -> Result<EmptyModel, RequestError> {
        let endpoint = Chat2AppEndpoint.addMessageFromOperator(text: text, firstMessageText: Chat2App.shared.firstMessageText)
        return await sendRequest(endpoint: endpoint, responseModel: EmptyModel.self)
    }
    
    func accountStatus() async -> Result<AccountStatusModel, RequestError>{
        let endpoint = Chat2AppEndpoint.accountStatus
        return await sendRequest(endpoint: endpoint, responseModel: AccountStatusModel.self)
    }
    
    func sendTemplateMessageIfNeeded(templateName: String) async -> Result<Bool, RequestError>{
        let endpoint = Chat2AppEndpoint.sendTemplateMessageIfNeeded(templateName: templateName)
        return await sendRequest(endpoint: endpoint, responseModel: Bool.self)
    }
    
    func checkFriendLinkTapAndSendDiscountIfNeeded() async ->Result<ChatCheckFriendLinkTapAndSendDiscountIfNeededResult, RequestError>{
        let endpoint = Chat2AppEndpoint.checkFriendLinkTapAndSendDiscountIfNeeded
        return await sendRequest(endpoint: endpoint, responseModel: ChatCheckFriendLinkTapAndSendDiscountIfNeededResult.self)
    }
    
    
    func chatInfo(text: String?, firstMessageText: String?) async -> Result<ChatInfo, RequestError> {
        let endpoint = Chat2AppEndpoint.chatInfo(text: text, firstMessageText: firstMessageText)
        return await sendRequest(endpoint: endpoint, responseModel: ChatInfo.self)
    }
    
    func sendImage(text: String?, imageData: Data) async -> Result<ChatInfo, RequestError>{
        let endpoint = Chat2AppEndpoint.sendImage(text: text, imageData: imageData)
        return await sendRequest(endpoint: endpoint, responseModel: ChatInfo.self)
    }
    
    func unreadMessagesCnt() async -> Result<ChatUnreadMessagesCnt, RequestError>{
        let endpoint = Chat2AppEndpoint.unreadMessagesCnt
        return await sendRequest(endpoint: endpoint, responseModel: ChatUnreadMessagesCnt.self)
    }
    
    func lastMessageId() async -> Result<LastMessageId, RequestError>{
        let endpoint = Chat2AppEndpoint.lastMessageId
        return await sendRequest(endpoint: endpoint, responseModel: LastMessageId.self)
    }
    
    func sendUserData(userData: [String: String]) async -> Result<EmptyModel, RequestError>{
        let endpoint = Chat2AppEndpoint.userData(userData: userData)
        return await sendRequest(endpoint: endpoint, responseModel: EmptyModel.self)
    }
    
    func logEvent(name: String, value: Chat2App.EventValue) async -> Result<EmptyModel, RequestError>{
        let endpoint = Chat2AppEndpoint.logEvent(name: name, value: value)
        return await sendRequest(endpoint: endpoint, responseModel: EmptyModel.self)
    }
    
}
