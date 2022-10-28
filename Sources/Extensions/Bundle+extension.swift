//
//  Bundle+extension.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation

extension Bundle {
  #if IS_SPM
  internal static var messageKitAssetBundle = Bundle.module
  #else
  internal static var messageKitAssetBundle: Bundle {
    Bundle(for: Chat2AppViewController.self)
  }
  #endif
}
