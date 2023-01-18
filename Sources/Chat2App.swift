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
    
    var apiKey: String = ""
    var appId: String = ""
    var chatUserName: String = ""
    var chatUserId: String = ""
    var userData: [String:String]? = nil
    var accountStatus: AccountStatus? = nil
    public var operatorName: String = "Operator"
    public var firstMessageText: String = ""
    
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
