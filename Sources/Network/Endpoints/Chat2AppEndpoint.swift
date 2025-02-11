//
//  Chat2AppEndpoint.swift
//  
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation
import DeviceKit

enum Chat2AppEndpoint {
    case chatInfo(text: String?, firstMessageText: String?)
    case sendImage(text: String?, imageData: Data)
    case unreadMessagesCnt
    case lastMessageId
    case userData(userData: [String:String])
    case accountStatus
    case addMessageFromOperator(text: String, firstMessageText: String?)
    case sendTemplateMessageIfNeeded(templateName: String)
    case checkFriendLinkTapAndSendDiscountIfNeeded
}

extension Chat2AppEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .chatInfo:
            return "/api/ChatInfo"
        case .sendImage:
            return "/api/ChatInfo"
        case .unreadMessagesCnt:
            return "/api/UnreadMessagesCnt"
        case .lastMessageId:
            return "/api/LastMessageId"
        case .userData:
            return "/api/UserData"
        case .accountStatus:
            return "/api/AccountStatus"
        case .addMessageFromOperator:
            return "/api/AddMessageFromOperator"
        case .sendTemplateMessageIfNeeded:
            return "/api/SendTemplateMessageIfNeeded"
        case .checkFriendLinkTapAndSendDiscountIfNeeded:
            return "/api/DidUserTapPromoCodeRecently"
        }
    }

    var method: RequestMethod {
        switch self {
        case .chatInfo:
            return .post
        case .sendImage:
            return .post
        case .unreadMessagesCnt:
            return .get
        case .lastMessageId:
            return .get
        case .userData:
            return .post
        case .accountStatus:
            return .get
        case .addMessageFromOperator:
            return .post
        case .sendTemplateMessageIfNeeded:
            return .post
        case .checkFriendLinkTapAndSendDiscountIfNeeded:
            return .post
        }
    }

    var header: [String: String]? {
        let device = Device.current
        let apiKey = Chat2App.shared.apiKey
        let appId = Chat2App.shared.appId
        let chatUserName = Chat2App.shared.chatUserName
        let chatUserId = Chat2App.shared.chatUserId
        let locale = Chat2App.shared.locale
        let languageCode = Chat2App.shared.language.code
        let pushToken = Chat2App.shared.apnsTokenString ?? ""
        let revenuecat_user_id = Chat2App.shared.revenuecat_user_id
        switch self {
        case .sendImage:
            return [
                "apiKey": apiKey,
                "appId": appId,
                "Content-Type": "multipart/form-data; boundary=\(MultipartFormDataRequest.boundary)",
                "Device": "\(device)",
                "pushToken": pushToken,
                "chatUserName": chatUserName,
                "chatLocale": locale,
                "languageCode": languageCode,
                "chatUserId": chatUserId,
                "revenuecat_user_id": revenuecat_user_id
            ]
        default:
            return [
                "apiKey": apiKey,
                "appId": appId,
                "Content-Type": "application/json;charset=utf-8",
                "Device": "\(device)",
                "pushToken": pushToken,
                "chatUserName": chatUserName,
                "chatLocale": locale,
                "languageCode": languageCode,
                "chatUserId": chatUserId,
                "revenuecat_user_id": revenuecat_user_id
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .chatInfo(let text, let firstMessageText):
            if let text = text {
                return [
                    "text": text
                ]
            } else if let firstMessageText = firstMessageText {
                return [
                    "first_message_text": firstMessageText
                ]
            }
            return nil
        case .userData(let userData):
            return userData
        case .addMessageFromOperator(let text, let firstMessageText):
            return [
                "text": text,
                "first_message_text": firstMessageText ?? ""
            ]
            
        case .sendTemplateMessageIfNeeded(let templateName):
            return [
                "templateName": templateName
            ]
            
        
        default:
            return nil
        }
    }
    
    var imageBody: Data? {
        switch self {
        case .sendImage(let text, let imageData):
            let request = MultipartFormDataRequest()
            request.addDataField(named: "image", data: imageData, mimeType: "image/jpeg", filename: "image.jpg")
            if let text = text {
                request.addTextField(named: "text", value: text)
            }
            return request.httpBodyData
        default:
            return nil
        }
    }
    
    var getParams: [String: String]? {
        return nil
    }
}
