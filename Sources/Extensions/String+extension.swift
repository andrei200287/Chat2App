//
//  String+extension.swift
//  
//
//  Created by Andrei Solovjev on 28/10/2022.
//

import Foundation
import UIKit
import SwiftMessages

extension String {
    
    func showUserErrorAlert() {
        DispatchQueue.main.async {
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            view.configureContent(title: "Error", body: self)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: .statusBar)
            SwiftMessages.show(config: config, view: view)
        }
    }

    func showSuccessAlert() {
        DispatchQueue.main.async {
            // Main queue
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(.success)
            view.configureDropShadow()
            view.configureContent(title: "", body: self)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: .statusBar)
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    func showPushAlert(title: String = "", completion: @escaping (()->())) {
        DispatchQueue.main.async {
            // Main queue
            let view = MessageView.viewFromNib(layout: .cardView)
            view.configureTheme(backgroundColor: .AppTintColor, foregroundColor: .white)
            view.configureDropShadow()
            view.configureContent(title: title, body: self)
            view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.button?.isHidden = true
            view.tapHandler = { _ in
                SwiftMessages.hide(animated: false)
                completion()
            }
            (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: .statusBar)
            SwiftMessages.show(config: config, view: view)
        }
    }
}
