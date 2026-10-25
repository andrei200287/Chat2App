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
    private var pushBannerView: PushEnableBannerView?
    private var appliedPushBannerInset: CGFloat = 0
    
    func setupRx(){
        self.viewModel.$chatInfo.dropFirst().receive(on: RunLoop.main).sink{ [weak self] (chatInfo) in
            self?.updateChatInfo(chatInfo: chatInfo)
        }.store(in: &cancellableSet)
    }
    
    func updateChatInfo(chatInfo: ChatInfo?){
        guard let chatInfo = chatInfo else { return }
        let name = Chat2App.shared.operatorName
        self.addAvatarToNavBar(avatarUrl: chatInfo.avatar, name: name)
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
    
    func addAvatarToNavBar(avatarUrl: String?, name: String?) {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 8

        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15.0

        if let avatarUrl = avatarUrl, let url = URL(string: avatarUrl) {
            let size: CGSize = CGSize(width: 90.0, height: 90.0)
            let processor = DownsamplingImageProcessor(size: size)
                         |> RoundCornerImageProcessor(cornerRadius: 45)
            imageView.kf.setImage(with: url, options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
        }

        container.addArrangedSubview(imageView)

        if let name = name {
            if !name.isEmpty {
                let label = UILabel()
                label.text = name
                label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
                label.textColor = .AppTextColor
                container.addArrangedSubview(label)
            }
            
        }

        self.navigationItem.titleView = container
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
        self.showPushBannerIfNeeded()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let pushBannerView = pushBannerView {
            view.bringSubviewToFront(pushBannerView)
        }
        updatePushBannerInset()
    }

    func addCloseButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeChat))
    }

    //MARK: - Push banner

    func updatePushBannerVisibility() {
        guard isViewLoaded else { return }
        if Chat2App.shared.showEnablePushInSettings {
            let wasHidden = pushBannerView == nil
            showPushBannerIfNeeded()
            guard wasHidden, let banner = pushBannerView else { return }
            banner.alpha = 0
            view.layoutIfNeeded()
            updatePushBannerInset()
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
                banner.alpha = 1
            }
        } else {
            hidePushBanner(callCloseHandler: false)
        }
    }

    private func showPushBannerIfNeeded() {
        guard Chat2App.shared.showEnablePushInSettings else { return }
        guard pushBannerView == nil else { return }

        let banner = PushEnableBannerView(
            title: Chat2App.shared.pushBannerTitle,
            text: Chat2App.shared.pushBannerText
        )
        banner.onClose = { [weak self] in
            self?.dismissPushBanner()
        }
        banner.onEnable = {
            Chat2App.shared.didTapEnablePush?()
        }
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        pushBannerView = banner
    }

    private func dismissPushBanner() {
        hidePushBanner(callCloseHandler: true)
    }

    private func hidePushBanner(callCloseHandler: Bool) {
        guard let banner = pushBannerView else { return }
        pushBannerView = nil
        appliedPushBannerInset = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) {
            banner.alpha = 0
            self.messagesCollectionView.contentInset.top = 0
            self.messagesCollectionView.verticalScrollIndicatorInsets.top = 0
        } completion: { _ in
            banner.removeFromSuperview()
        }
        if callCloseHandler {
            Chat2App.shared.didTapClosePushBanner?()
        }
    }

    private func updatePushBannerInset() {
        let height = pushBannerView?.bounds.height ?? 0
        guard abs(appliedPushBannerInset - height) > 0.5 else { return }
        appliedPushBannerInset = height
        messagesCollectionView.contentInset.top = height
        messagesCollectionView.verticalScrollIndicatorInsets.top = height
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
