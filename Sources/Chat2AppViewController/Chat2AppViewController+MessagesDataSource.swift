//
//  Chat2AppViewController+MessagesDataSource.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import UIKit
import MessageKit

extension Chat2AppViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        viewModel.user
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        self.viewModel.messageList[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        self.viewModel.messageList.count
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
        let dateString = message.sentDate.appDateFormat()
        return NSAttributedString(
        string: dateString,
        attributes: [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
          NSAttributedString.Key.foregroundColor: UIColor.darkGray,
        ]
      )
    }
    
    func cellBottomLabelAttributedText(for _: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
}
