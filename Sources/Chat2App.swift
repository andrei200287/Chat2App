//
//  Chat2App.swift
//  Chat2App
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import Foundation
import UIKit

public class Chat2App {
    
    public static let shared = Chat2App()
    
    public enum Language: String {
        case ar = "Arabic"
        case bg = "Bulgarian"
        case zh = "Chinese (Simplified)"
        case zhHant = "Chinese (Traditional)"
        case hr = "Croatian"
        case cs = "Czech"
        case da = "Danish"
        case nl = "Dutch"
        case en = "English"
        case et = "Estonian"
        case fi = "Finnish"
        case fr = "French"
        case de = "German"
        case el = "Greek"
        case he = "Hebrew"
        case hi = "Hindi"
        case hu = "Hungarian"
        case id = "Indonesian"
        case it = "Italian"
        case ja = "Japanese"
        case ko = "Korean"
        case lv = "Latvian"
        case lt = "Lithuanian"
        case ms = "Malay"
        case nb = "Norwegian"
        case pl = "Polish"
        case pt = "Portuguese"
        case ro = "Romanian"
        case ru = "Russian"
        case sk = "Slovak"
        case sl = "Slovenian"
        case es = "Spanish"
        case sv = "Swedish"
        case th = "Thai"
        case tr = "Turkish"
        case uk = "Ukrainian"
        case vi = "Vietnamese"
        
        var langName: String {
            return self.rawValue
        }
        
        var code: String {
            switch self {
            case .ar: return "ar"
            case .bg: return "bg"
            case .zh: return "zh"
            case .zhHant: return "zh-Hant"
            case .hr: return "hr"
            case .cs: return "cs"
            case .da: return "da"
            case .nl: return "nl"
            case .en: return "en"
            case .et: return "et"
            case .fi: return "fi"
            case .fr: return "fr"
            case .de: return "de"
            case .el: return "el"
            case .he: return "he"
            case .hi: return "hi"
            case .hu: return "hu"
            case .id: return "id"
            case .it: return "it"
            case .ja: return "ja"
            case .ko: return "ko"
            case .lv: return "lv"
            case .lt: return "lt"
            case .ms: return "ms"
            case .nb: return "nb"
            case .pl: return "pl"
            case .pt: return "pt"
            case .ro: return "ro"
            case .ru: return "ru"
            case .sk: return "sk"
            case .sl: return "sl"
            case .es: return "es"
            case .sv: return "sv"
            case .th: return "th"
            case .tr: return "tr"
            case .uk: return "uk"
            case .vi: return "vi"
            }
        }
    }
    
    var apiKey: String = ""
    var appId: String = ""
    var chatUserName: String = ""
    var chatUserId: String = ""
    var userData: [String:String]? = nil
    var accountStatus: AccountStatus? = nil
    public var operatorName: String = "Operator"
    public var firstMessageText: String = ""
    public var language: Language = .en
    public var revenuecat_user_id: String = ""
    
    public var apnsToken: Data? {
        didSet {
            if let apnsToken = apnsToken {
                let tokenParts = apnsToken.map { data in String(format: "%02.2hhx", data) }
                let token = tokenParts.joined()
                apnsTokenString = token
            } else {
                apnsTokenString = nil
            }
        }
    }
    var apnsTokenString: String?
    var locale: String {
        Locale.current.identifier
    }
    weak var viewController: Chat2AppViewController?
    
    private lazy var networkService: Chat2AppNetworkServiceable = {
        Chat2AppNetworkService()
    }()
    
    public func setApiKeyForAppId(apiKey: String, appId: String) {
        self.apiKey = apiKey
        self.appId = appId
        Task {
            let result = await self.networkService.accountStatus()
            switch result {
            case .success(let accountStatus):
                self.accountStatus = accountStatus.status
                if self.accountStatus != .active {
                    let accountStatusString = self.accountStatus?.rawValue ?? "nil"
                    print("Chat2App: check account status: \(accountStatusString)")
                }
            case .failure(_):
                break
            }
        }
    }
    
    public func setChatUser(name: String, uniqId: String, userData: [String:String]?){
        self.chatUserName = name
        self.chatUserId = uniqId
        self.userData = userData
    }
    
    public enum EventValue {
        case string(String)
        case int(Int)
        case date(Date)
        case double(Double)
    }
    
    //logEvent(name: "UserAge", value: .int(28))
    public func logEvent(name: String, value: EventValue) async {
        let _ = await self.networkService.logEvent(name: name, value: value)
    }
    
    public func sendTemplateMessageIfNeeded(templateName: String) async -> Bool{
        let result = await self.networkService.sendTemplateMessageIfNeeded(templateName: templateName)
        switch result {
        case .success(let result):
            return result
        case .failure(_):
            return false
        }
    }
    
    public func checkFriendLinkTapAndSendDiscountIfNeeded() async -> Bool {
        let result = await self.networkService.checkFriendLinkTapAndSendDiscountIfNeeded()
        switch result {
        case .success(let model):
            return model.didUserTapPromoCodeRecently
        case .failure(_):
            return false
        }
    }
    
    public func sendFriendLinkMessage() async -> Bool {
        return await self.sendTemplateMessageIfNeeded(templateName: "FriendLinkMessage")
    }
    
    public func addMessageFromOperator(text: String) async -> Bool{
        let result = await self.networkService.addMessageFromOperator(text: text)
        switch result {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    public func presentMessenger(from viewController: UIViewController){
        if self.accountStatus != .active {
            print("Chat2App: your account status: \(String(describing: self.accountStatus)). To show the chat, the account must be in the status \(AccountStatus.active.rawValue)")
            return
        }
        let vc = Chat2AppViewController()
        let nav = UINavigationController(rootViewController: vc)
        vc.viewModel = Chat2AppViewModel(chat2AppService: self.networkService, chatUserName: self.chatUserName, chatUserId: self.chatUserId)
        nav.modalPresentationStyle = .fullScreen
        viewController.present(nav, animated: true)
        self.viewController = vc
    }
    
    public func unreadMessagesCnt() async -> Int {
        let result = await self.networkService.unreadMessagesCnt()
        switch result {
        case .success(let chatUnreadMessagesCnt):
            return chatUnreadMessagesCnt.unreadMessagesCnt
        case .failure(_):
            return 0
        }
    }
    
    public func sendUserData(userData: [String:String]) async -> Bool {
        let result = await self.networkService.sendUserData(userData: userData)
        switch result {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    public func sendUserData() {
        guard let userData = Chat2App.shared.userData else { return }
        Task(priority: .high) {
            _ = await Chat2App.shared.sendUserData(userData: userData)
        }
    }
    
    public func handlePushNotification(userInfo: [AnyHashable : Any]) {
        guard let service = userInfo["service"] as? String else {
            return
        }
        if service != "Chat2App" {
            return
        }
        
        if let viewController = viewController {
            // reload data
            viewController.reloadDataFromPush()
        } else {
            if let aps = userInfo["aps"] as? NSDictionary {
                if let alertMessage = aps["alert"] as? String {
                    alertMessage.showPushAlert(title: "New message") {
                        DispatchQueue.main.async {
                            if let rootViewController = UIWindow.keyWindow?.rootViewController {
                                Chat2App.shared.presentMessenger(from: rootViewController)
                            }
                        }
                    }
                }
            }
            
        }
    }
}
