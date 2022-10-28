//
//  Chat2AppViewController+MessagesLayoutDelegate.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import UIKit
import MessageKit

extension Chat2AppViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        18
    }

    func cellBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        17
    }

    func messageTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        20
    }

    func messageBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        16
    }
}
