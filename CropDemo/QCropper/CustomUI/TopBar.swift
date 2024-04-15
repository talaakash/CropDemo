//
//  TopBar.swift
//
//  Created by Chen Qizhi on 2019/10/15.
//

import UIKit

class TopBar: UIView {
    lazy var flipButton: UIButton = {
        let button = self.iconButton(iconName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill", isSystemName: true)
        // button.left = 0
        button.right = self.width - 16.0
        button.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
        return button
    }()

//    lazy var rotateButton: UIButton = {
//        let button = self.iconButton(iconName: "rotate.right.fill", isSystemName: true)
//        // button.left = self.flipButton.right
//        button.right = self.flipButton.left
//        button.autoresizingMask = [.flexibleTopMargin, .flexibleRightMargin]
//        return button
//    }()

    lazy var aspectRationButton: UIButton = {
        let button = self.iconButton(iconName: "aspectratio.fill", isSystemName: true)
        button.right = self.width
        button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        return button
    }()

    lazy var blurBackgroundView: UIVisualEffectView = {
        let vev = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        vev.alpha = 0.3
        vev.backgroundColor = .clear
        vev.frame = self.bounds
        vev.isUserInteractionEnabled = false
        vev.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleHeight, .flexibleWidth]
        return vev
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(blurBackgroundView)
        addSubview(flipButton)
//        addSubview(rotateButton)
//         addSubview(aspectRationButton)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func iconButton(iconName: String, isSystemName: Bool = false) -> UIButton {
        let button = IconButton(iconName, isSystemName: isSystemName)
        button.bottom = height
        return button
    }
}

class IconButton: UIButton {
    init(_ iconName: String, isSystemName: Bool = false) {
        super.init(frame: CGRect(center: .zero, size: CGSize(width: 44, height: 44)))
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .regular)
        let image = isSystemName ? UIImage(systemName: iconName, withConfiguration: config) : UIImage(named: iconName, in: QCropper.Config.resourceBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        tintColor = QCropper.Config.tintColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                tintColor = QCropper.Config.highlightColor
            } else {
                tintColor = QCropper.Config.tintColor
            }
        }
    }
}
