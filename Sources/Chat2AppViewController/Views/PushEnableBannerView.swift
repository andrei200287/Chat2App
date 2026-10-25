//
//  PushEnableBannerView.swift
//  Chat2App
//
//  Created by Andrei Solovjev on 25/10/2026.
//

import UIKit

final class PushEnableBannerView: UIView {

    var onClose: (() -> Void)?
    var onEnable: (() -> Void)?

    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let toggle = UISwitch()

    init(title: String, text: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        bodyLabel.text = text
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        overrideUserInterfaceStyle = .dark
        backgroundColor = UIColor(red: 34.0 / 255.0, green: 35.0 / 255.0, blue: 39.0 / 255.0, alpha: 1)

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0

        bodyLabel.font = .systemFont(ofSize: 15, weight: .regular)
        bodyLabel.textColor = UIColor(red: 161.0 / 255.0, green: 164.0 / 255.0, blue: 170.0 / 255.0, alpha: 1)
        bodyLabel.numberOfLines = 0

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: symbolConfig), for: .normal)
        closeButton.tintColor = UIColor(red: 174.0 / 255.0, green: 176.0 / 255.0, blue: 181.0 / 255.0, alpha: 1)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.accessibilityLabel = "Close"

        toggle.isOn = false
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        toggle.accessibilityLabel = titleLabel.text

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        bodyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.setContentHuggingPriority(.required, for: .horizontal)
        toggle.setContentCompressionResistancePriority(.required, for: .horizontal)
        toggle.setContentHuggingPriority(.required, for: .horizontal)
        toggle.setContentHuggingPriority(.required, for: .vertical)

        let titleRow = UIStackView(arrangedSubviews: [titleLabel, closeButton])
        titleRow.axis = .horizontal
        titleRow.alignment = .center
        titleRow.spacing = 8

        let bodyRow = UIStackView(arrangedSubviews: [bodyLabel, toggle])
        bodyRow.axis = .horizontal
        bodyRow.alignment = .center
        bodyRow.spacing = 12

        let stack = UIStackView(arrangedSubviews: [titleRow, bodyRow])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),

            stack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12)
        ])
    }

    @objc private func closeTapped() {
        onClose?()
    }

    @objc private func switchChanged(_ sender: UISwitch) {
        guard sender.isOn else { return }
        sender.setOn(false, animated: true)
        onEnable?()
    }
}
