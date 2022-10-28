//
//  Chat2AppViewController+InputBarAccessoryViewDelegate.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import MessageKit
import InputBarAccessoryView


// MARK: InputBarAccessoryViewDelegate
extension Chat2AppViewController: CameraInputBarAccessoryViewDelegate {
  // MARK: Internal

  @objc
  func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
    processInputBar(messageInputBar)
  }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith attachments: [AttachmentManager.Attachment]) {
        let text = inputBar.inputTextView.text
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        inputBar.inputTextView.resignFirstResponder()
        
        for item in attachments {
          if case .image(let image) = item {
              let imageData = image.jpegData(compressionQuality: 0.9)!
              self.viewModel.sendImage(text: text, imageData: imageData) {
                    DispatchQueue.main.async {
                        self.messagesCollectionView.reloadData()
                        inputBar.sendButton.stopAnimating()
                        inputBar.inputTextView.placeholder = "Aa"
                        self.messagesCollectionView.scrollToLastItem(animated: true)
                    }
                }
              break
          }
        }
        inputBar.invalidatePlugins()
    }

  func processInputBar(_ inputBar: InputBarAccessoryView) {
      let attributedText = inputBar.inputTextView.attributedText!
      inputBar.inputTextView.text = String()
      inputBar.invalidatePlugins()
      inputBar.sendButton.startAnimating()
      inputBar.inputTextView.placeholder = "Sending..."
      inputBar.inputTextView.resignFirstResponder()
        
        self.viewModel.sendMessage(text: attributedText.string) {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
  }

  
}
