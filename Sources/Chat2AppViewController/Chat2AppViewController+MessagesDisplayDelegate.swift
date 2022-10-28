//
//  Chat2AppViewController+MessagesDisplayDelegate.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import MessageKit
import MapKit
import LetterAvatarKit
import Kingfisher

// MARK: MessagesDisplayDelegate
extension Chat2AppViewController: MessagesDisplayDelegate {
  // MARK: - Text Messages

  func textColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
      .white
  }

  func detectorAttributes(for detector: DetectorType, and _: MessageType, at _: IndexPath) -> [NSAttributedString.Key: Any] {
      return [.foregroundColor: UIColor.AppTintColor]
  }

  func enabledDetectors(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> [DetectorType] {
      [.url, .address, .phoneNumber, .transitInformation, .mention, .hashtag]
  }

  // MARK: - All Messages

  func backgroundColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? UIColor.AppChatMessageBackgroundColorCurrentSender : UIColor.AppChatMessageBackgroundColor
  }

  func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
      let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
      return .bubbleTail(tail, .curved)
  }

  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) {
      let user = self.viewModel.chatInfo?.users.first(where: { user in
          user.userId == message.sender.senderId
      })
      let avatarImage = LetterAvatarMaker()
          .setCircle(true)
          .setUsername(message.sender.displayName)
          .setBorderWidth(1.0)
          .setBackgroundColors([ .red ])
          .build()
      if let avatarUrlString = user?.avatar {
          let url = URL(string: avatarUrlString)
          avatarView.kf.setImage(with: url, placeholder: avatarImage)
      } else {
          let avatar = Avatar(image: avatarImage, initials: "")
          avatarView.set(avatar: avatar)
      }
  }

  func configureMediaMessageImageView(
    _ imageView: UIImageView,
    for message: MessageType,
    at _: IndexPath,
    in _: MessagesCollectionView)
  {
      if case MessageKind.photo(let media) = message.kind, let imageURL = media.url {
        imageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "image_message_placeholder", in: Bundle.messageKitAssetBundle, with: nil) ?? UIImage())
      } else {
        imageView.kf.cancelDownloadTask()
      }
  }

  
}
