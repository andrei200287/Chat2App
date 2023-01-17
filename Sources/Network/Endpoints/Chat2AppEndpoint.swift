//
//  Chat2AppEndpoint.swift
//  
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation
import DeviceKit

enum Chat2AppEndpoint {
    case chatInfo(text: String?)
    case sendImage(text: String?, imageData: Data)
    case unreadMessagesCnt
    case lastMessageId
    case userData(userData: [String:String])
    case accountStatus
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
        }
    }

    var header: [String: String]? {
        let device = Device.current
        let apiKey = Chat2App.shared.apiKey
        let appId = Chat2App.shared.appId
        let chatUserName = Chat2App.shared.chatUserName
        let chatUserId = Chat2App.shared.chatUserId
        let locale = Chat2App.shared.locale
        let pushToken = Chat2App.shared.apnsTokenString ?? ""
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
                "chatUserId": chatUserId
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
                "chatUserId": chatUserId
            ]
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .chatInfo(let text):
            if let text = text {
                return [
                    "text": text
                ]
            }
            return nil
        case .userData(let userData):
            return userData
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
