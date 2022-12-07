//
//  Chat2AppViewController.swift
//  
//
//  Created by Andrei Solovjev on 26/10/2022.
//

import Foundation
import UIKit
import MessageKit
import Combine
import Kingfisher

protocol Chat2AppViewControllerDelegate: AnyObject {
    func showBigPic(image: UIImage)
}

class Chat2AppViewController: MessagesViewController {
    
    var viewModel: Chat2AppViewModel!
    weak var delegate: Chat2AppViewControllerDelegate?
    private var timer: Timer?
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    @objc
    func loadMoreMessages() {
        self.viewModel.loadChatInfo {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    public func loadMessageFromPush(){
        self.reloadChatInfo()
    }
    
    public func reloadChatInfo(){
        self.viewModel.loadChatInfo {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
            }
        }
    }
    
    var cancellableSet = Set<AnyCancellable>()
    
    func setupRx(){
        self.viewModel.$chatInfo.dropFirst().receive(on: RunLoop.main).sink{ [weak self] (chatInfo) in
            self?.updateChatInfo(chatInfo: chatInfo)
        }.store(in: &cancellableSet)
    }
    
    func updateChatInfo(chatInfo: ChatInfo?){
        guard let chatInfo = chatInfo else { return }
        if let avatarUrl = chatInfo.avatar {
            self.addAvatarToNavBar(avatarUrl: avatarUrl)
        }
    }
    
    //MARK: - Timer
    
    func setupTimer() {
        self.stopTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        Task {
            let shouldUpdate = await self.viewModel.shouldUpdate()
            if shouldUpdate == true {
                self.reloadChatInfo()
            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func addAvatarToNavBar(avatarUrl: String){
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        imageView.kf.indicatorType = .activity
        let url = URL(string: avatarUrl)
        let size: CGSize = CGSize(width: 90.0, height: 90.0)
        let processor = DownsamplingImageProcessor(size: size)
                     |> RoundCornerImageProcessor(cornerRadius: 45)
        imageView.kf.setImage(with: url, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        imageView.contentMode = .scaleAspectFit
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func setupStyle(){
        view.backgroundColor = .AppBackgroundColor
        messagesCollectionView.backgroundColor = .AppBackgroundColor
        navigationController?.navigationBar.barTintColor = .AppBarTintColor
        navigationController?.navigationBar.tintColor = .AppTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.AppTextColor]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.AppTextColor]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRx()
        configureMessageCollectionView()
        configureMessageInputBar()
        
        self.setupStyle()
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        self.showLoader()
        self.viewModel.loadChatInfo {
            DispatchQueue.main.async {
                self.hideLoader()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
            }
        }
        self.viewModel.sendUserData()
        self.addCloseButton()
        self.setupTimer()
    }
    
    public func reloadDataFromPush(){
        self.viewModel.loadChatInfo {
            DispatchQueue.main.async {
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: false)
            }
        }
    }
    
    func addCloseButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeChat))
    }
    
    @objc func closeChat(){
        self.stopTimer()
        self.navigationController?.dismiss(animated: true) {
            Chat2App.shared.viewController = nil
        }
    }
    
    var activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    func showLoader(){
        activityView.color = .white
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func hideLoader(){
        activityView.stopAnimating()
        activityView.removeFromSuperview()
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true
        showMessageTimestampOnSwipeLeft = false

        messagesCollectionView.refreshControl = refreshControl
    }
    
     func configureMessageInputBar() {
         messageInputBar = CameraInputBarAccessoryView()
         messageInputBar.delegate = self
            messageInputBar.inputTextView.keyboardAppearance = .dark
         messageInputBar.sendButton.setTitleColor(.AppTintColor, for: .normal)
         messageInputBar.sendButton.setTitleColor(
           UIColor.red.withAlphaComponent(0.3),
           for: .highlighted)

         messageInputBar.isTranslucent = true
         messageInputBar.separatorLine.isHidden = true
         messageInputBar.inputTextView.tintColor = .AppTintColor
            messageInputBar.inputTextView.textColor = .AppTextColor
         messageInputBar.inputTextView.backgroundColor = UIColor(red: 44 / 255, green: 44 / 255, blue: 46 / 255, alpha: 1)
         messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
         messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
         messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
         messageInputBar.inputTextView.layer.borderColor = UIColor(red: 75 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1).cgColor
         messageInputBar.inputTextView.layer.borderWidth = 1.0
         messageInputBar.inputTextView.layer.cornerRadius = 16.0
         messageInputBar.inputTextView.layer.masksToBounds = true
         messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            messageInputBar.backgroundView.backgroundColor = UIColor(red: 31 / 255, green: 31 / 255, blue: 31 / 255, alpha: 1)
            messageInputBar.isTranslucent = false
         inputBarType = .custom(messageInputBar)
    }


}
