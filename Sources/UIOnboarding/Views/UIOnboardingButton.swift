//
//  UIOnboardingButton.swift
//  UIOnboarding
//
//  Created by Lukman Aščić on 14.02.22.
//

import UIKit

final class UIOnboardingButton: UIButton {
    
    weak var delegate: UIOnboardingButtonDelegate?
    private var fontName: String = ""
    
    convenience init(withConfiguration configuration: UIOnboardingButtonConfiguration) {
        self.init(type: .system)
        
        fontName = configuration.fontName
        
        var config: UIButton.Configuration
        
        if #available(iOS 26.0, *) {
            config = .prominentGlass()
            config.cornerStyle = .capsule
        } else {
            config = .tinted()
            config.cornerStyle = .large
        }
        
        config.title = configuration.title
        
        // Цвета (fallback для старых API)
        config.baseForegroundColor = configuration.titleColor
        config.baseBackgroundColor = configuration.backgroundColor
        
        // Insets (по желанию)
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        self.configuration = config
        
        configureFont()
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        titleLabel?.numberOfLines = 0

        translatesAutoresizingMaskIntoConstraints = false
        
        accessibilityTraits = .button
        isAccessibilityElement = true
        
        if #available(iOS 13.4, *) {
            isPointerInteractionEnabled = true
        }
        
        addTarget(self, action: #selector(handleCallToActionButton), for: .touchUpInside)
    }
        
    @objc private func handleCallToActionButton() {
        delegate?.didPressContinueButton()
    }
}

protocol UIOnboardingButtonDelegate: AnyObject {
    func didPressContinueButton()
}

extension UIOnboardingButton {
    func configureFont() {
        let fontSize: CGFloat = traitCollection.horizontalSizeClass == .regular ? 19 : 17
        
        let baseFont: UIFont
        
        if let customFont = UIFont(name: fontName, size: fontSize) {
            baseFont = customFont
        } else {
            baseFont = .systemFont(ofSize: fontSize, weight: .bold)
        }
        
        let scaledFont = UIFontMetrics.default.scaledFont(for: baseFont)
        
        var container = AttributeContainer()
        container.font = scaledFont
        
        var updatedConfig = configuration
        updatedConfig?.attributedTitle = AttributedString(configuration?.title ?? "", attributes: container)
        
        configuration = updatedConfig
    }
}
