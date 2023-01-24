<h3 align="center">Best Live Customer Chat Platform for iOS apps</h3>

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-orange.svg)](https://docs.revenuecat.com/docs/ios#section-install-via-swift-package-manager)

Simple and modern customer support platform designed to be as convenient as possible. Get started in minutes.

Sign up to [get started for free](https://chat2app.com).

## Chat2App.framework
*Chat2App* is the client for the [Chat2App](https://chat2app.com/) live customer chat platform. It's 100% `Swift`.

## Requirements

| Platform | Minimum target |
| --- | --- |
| iOS | 15.0+ |


## Quickstart Guide

## 1. Create a Chat2App Account
Sign up for a new Chat2App account [here](https://chat2app.com/SignUp).

## 2. Add your app
Сlick on the button 'Add new app' [here](https://chat2app.com/client/apps) and fill out the form for adding a new app:
* **App Name** - The name of your app in our system.
* **API KEY** - The API KEY grants you access to all of the features and functionality of our SDK, allowing you to easily integrate it into your app. Simply add your key to the designated param in the SDK settings and start using it right away. 
* **Bundle ID** - A bundle ID is a unique identifier that is assigned to your app by Apple. It is used to identify your app in the iOS App Store and ensure that it is not confused with any other app. The bundle ID is typically in the format of "com.yourcompanyname.yourappname" and can be found in your app's Xcode project settings or in the Apple Developer Member Center. 
* **Apple ID** - An automatically generated ID assigned to your app. Simply search for the app in question and click on it to open the app's page. The app's ID will be displayed in the URL of the page. It will be a string of numbers and letters after the "id" parameter. For example, in the URL "https://apps.apple.com/us/app/example-app/id1234567890", the app's ID is "1234567890". Alternatively, you can find this information on the app page on https://appstoreconnect.apple.com/. This field aren't required.
* **Avatar** - Upload a picture of operator or any other image that represents your app.

## 3. Set Apple Push Notification Settings
Keep your users informed about new messages by enabling push notifications. This settings aren't required.
* **Team ID** - Your Team ID can be easily located in the [Apple Developer Member Center](https://developer.apple.com/account/#/membership). Simply log in to your account and navigate to the 'Membership' section. Your Team ID will be prominently displayed, ready for you to use in your app development projects. 
* **Key ID** - You can find your Key ID in the Apple developer account. Log in to your account and navigate to the 'Certificates, Identifiers & Profiles' section. From there, select 'Keys' from the sidebar. Your Key ID will be listed here, along with any other keys you've created. If you don't have a key yet, you can create one by clicking the "+" button. With the key ID in hand, you can generate an APNs authentication token and start sending push notifications to your users.
* **Auth Key P8 File** The Auth Key P8 file is a private key file that is used to generate an APNs token that is required to send push notifications to your app. You can find your Auth Key P8 file in the Apple developer account. Log in to your account and navigate to the 'Certificates, Identifiers & Profiles' section. From there, select 'Keys' from the sidebar. Your Auth Key P8 file will be listed here. If you don't have a key yet, you can create one by clicking the "+" button. Once you have the Auth Key P8 file you can generate an APNs token and start sending push notifications to your users


## 4. Install Chat2App SDK via Swift Package Manager

1. In Xcode, select File > Swift Packages > Add Package Dependency.
1. Follow the prompts using the URL for this repository.

## 5. Configure the SDK

Configure SDK in your `AppDelegate.swift` to be able to use Chat2App in your whole project.


``` Swift
import Chat2App

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Chat2App.shared.setApiKeyForAppId(apiKey: <chat2app_api_key>, appId: <chat2app_app_id>)
    Chat2App.shared.operatorName = "<Operator name>"
    Chat2App.shared.firstMessageText = "<First message text>"
}

```

## 6. Configure Apple Push Notifications
 Push notifications are a powerful tool for engaging with your users, but the way you use them should be tailored to your specific business needs. This example shows how to set up permission request for push notifications right after app launch in your `AppDelegate.swift`.
``` Swift
import Chat2App

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Chat2App.shared.setApiKeyForAppId(apiKey: <chat2app_api_key>, appId: <chat2app_app_id>)
    Chat2App.shared.operatorName = "<Operator name>"
    Chat2App.shared.firstMessageText = "<First message text>"
    self.registerForPushNotifications()
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


```

## 7. Chat user configuration
Сonfigure the chat user by specifying his name, unique identifier and a set of additional data.

``` Swift
Chat2App.shared.setChatUser(name: ""<User name>"", uniqId: ""<uniq id>"", userData: ["foo":"bar"])
```
* **name** - The name under which you will see the user in the chat.
* **uniqId** - A unique identifier by which our system can identify the user. We recommend storing a unique user ID in iCloud `NSUbiquitousKeyValueStore` so that the same chat is available on all devices.
* **userData** - Any data about the user that you want to see in the chat, for example, device, iOS version, interface language, whether the user has subscribed, etc.

## 8. Show chat
``` Swift
Chat2App.shared.presentMessenger(from: self)
```

## 9. Sending a Message On Behalf of the Operator
``` Swift
Task {
    await Chat2App.shared.addMessageFromOperator(text: "Your message")
}
```

## Download Chat2App app
In order to respond to user messages, download Chat2App app from Apstore.

