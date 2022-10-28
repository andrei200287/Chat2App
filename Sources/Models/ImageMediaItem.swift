//
//  ImageMediaItem.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import UIKit
import MessageKit

struct ImageMediaItem: MediaItem {
  var url: URL?
  var image: UIImage?
  var placeholderImage: UIImage
  var size: CGSize

  init(image: UIImage) {
      self.image = image
      size = CGSize(width: 240, height: 240)
      placeholderImage = UIImage()
  }

  init(imageURL: URL) {
      url = imageURL
      size = CGSize(width: 240, height: 240)
      placeholderImage = UIImage(named: "image_message_placeholder", in: Bundle.messageKitAssetBundle, with: nil) ?? UIImage()
  }
}
