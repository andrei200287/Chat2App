//
//  UIColor+extension.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import UIKit

extension UIColor {
    internal static var AppBackgroundColor: UIColor { colorFromAssetBundle(named: "AppBackgroundColor") }
    internal static var AppTextColor: UIColor { colorFromAssetBundle(named: "AppTextColor") }
    internal static var AppButtonColor: UIColor { colorFromAssetBundle(named: "AppButtonColor") }
    internal static var AppCellHighlightedColor: UIColor { colorFromAssetBundle(named: "AppCellHighlightedColor") }
    internal static var AppChatMessageBackgroundColorCurrentSender: UIColor { colorFromAssetBundle(named: "AppChatMessageBackgroundColorCurrentSender") }
    internal static var AppChatMessageBackgroundColor: UIColor { colorFromAssetBundle(named: "AppChatMessageBackgroundColor") }
    internal static var AppBarTintColor: UIColor { colorFromAssetBundle(named: "AppBarTintColor") }
    internal static var AppTintColor: UIColor { colorFromAssetBundle(named: "AppTintColor") }
    internal static var AppMessageInputBarBackgroundColor: UIColor { colorFromAssetBundle(named: "AppMessageInputBarBackgroundColor") }
    
    
    // MARK: Private

    private static func colorFromAssetBundle(named: String) -> UIColor {
      guard let color = UIColor(named: named, in: Bundle.messageKitAssetBundle, compatibleWith: nil) else {
        fatalError(Chat2AppError.couldNotFindColorAsset)
      }
      return color
    }
}
