//
//  AppDelegate.swift
//  Chat2AppExample
//
//  Created by Andrei Solovjev on 25/10/2022.
//

import UIKit
import Chat2App

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Chat2App.shared.setApiKeyForAppId(apiKey: Constants.apiKey, appId: Constants.appId)
        Chat2App.shared.operatorName = "Andrew"
        Chat2App.shared.firstMessageText = "Welcome to our chat support! We're here to assist you with any questions or issues you may have. Please let us know how we can help you today."
        self.registerForPushNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Chat2App.shared.apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        Chat2App.shared.handlePushNotification(userInfo: userInfo)
    }
    
    func registerForPushNotifications() {
        Task(priority: .high) { [weak self] in
            do {
                let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
                print("granted = \(granted)")
                if granted == true {
                    DispatchQueue.main.async {
                        self?.getNotificationSettings()
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }


}

