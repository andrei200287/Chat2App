//
//  Chat2AppViewController+MessageCellDelegate.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import MessageKit
import MapKit

// MARK: MessageCellDelegate
extension Chat2AppViewController: MessageCellDelegate {
    func didTapAvatar(in _: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in _: MessageCollectionViewCell) {
        print("Message tapped")
    }

    func didTapImage(in cell: MessageCollectionViewCell) {
        if let mediaCell = cell as? MediaMessageCell, let image = mediaCell.imageView.image {
            let vc = ImageViewerViewController(nibName: "ImageViewerViewController", bundle: Bundle.messageKitAssetBundle)
            vc.image = image
            self.navigationController?.present(vc, animated: true)
        }
        print("Image tapped")
    }

    func didTapCellTopLabel(in _: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }

    func didTapCellBottomLabel(in _: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }

    func didTapMessageTopLabel(in _: MessageCollectionViewCell) {
        print("Top message label tapped")
    }

    func didTapMessageBottomLabel(in _: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapPlayButton(in cell: AudioMessageCell) {
        print("didTapPlayButton")
    }

    func didStartAudio(in _: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in _: AudioMessageCell) {
        print("Did pause audio sound")
    }

    func didStopAudio(in _: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in _: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
    func didSelectURL(_ url: URL) {
        UIApplication.shared.open(url)
        print("Selected URL \(url.absoluteString)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Selected phoneNumber \(phoneNumber)")
    }

}
