//
//  AlertService.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import UIKit

class AlertService {
  static func showAlert(
    style: UIAlertController.Style,
    title: String?,
    message: String?,
    actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)],
    completion: (() -> Swift.Void)? = nil)
  {
      let alert = UIAlertController(title: title, message: message, preferredStyle: style)
      for action in actions {
          alert.addAction(action)
      }
      Chat2App.shared.viewController?.present(alert, animated: true, completion: completion)

  }
}
