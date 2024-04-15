//
//  AspectRatioPicker.swift
//
//  Created by Chen Qizhi on 2019/10/15.
//

import UIKit

enum Box {
    case none
    case vertical
    case horizontal
}

protocol AspectRatioPickerDelegate: AnyObject {
    func aspectRatioPickerDidSelectedAspectRatio(_ aspectRatio: AspectRatio)
}

public class AspectRatioPicker: UIView {

    weak var delegate: AspectRatioPickerDelegate?

    var selectedAspectRatio: AspectRatio = .freeForm {
        didSet {
            let buttonIndex = aspectRatios.firstIndex(of: selectedAspectRatio) ?? 0
            scrollView.subviews.forEach { view in
                if let button = view as? UIButton, button.tag == buttonIndex {
                    button.isSelected = true
                    scrollView.scrollRectToVisible(button.frame.insetBy(dx: -30, dy: 0), animated: true)
                }
            }
        }
    }

    var selectedBox: Box = .none {
        didSet {
            switch selectedBox {
            case .none:
                horizontalButton.isSelected = false
                verticalButton.isSelected = false
            case .vertical:
                horizontalButton.isSelected = false
                verticalButton.isSelected = true
            case .horizontal:
                horizontalButton.isSelected = true
                verticalButton.isSelected = false
            }
        }
    }

    var rotated: Bool = false

    var aspectRatios: [AspectRatio] = [] {
        didSet {
            reloadScrollView()
        }
    }

    var scrollView: UIScrollView!
    var verticalButton: UIButton!
    var horizontalButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let boxButtonShortSide: CGFloat = 21
        let boxButtonLongSide: CGFloat = 31
        
        verticalButton = boxButton(size: CGSize(width: boxButtonShortSide, height: boxButtonLongSide))
        verticalButton.left = (width - boxButtonShortSide - boxButtonLongSide - 15) / 2
        verticalButton.centerY = 16
        verticalButton.addTarget(self, action: #selector(verticalButtonPressed(_:)), for: .touchUpInside)
        
        horizontalButton = boxButton(size: CGSize(width: boxButtonLongSide, height: boxButtonShortSide))
        horizontalButton.left = verticalButton.right + 15
        horizontalButton.centerY = verticalButton.centerY
        horizontalButton.addTarget(self, action: #selector(horizontalButtonPressed(_:)), for: .touchUpInside)

        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = .clear
        scrollView.decelerationRate = .fast
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false

        addSubview(scrollView)
        // addSubview(horizontalButton)
        // addSubview(verticalButton)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func reloadScrollView() {

        scrollView.subviews.forEach { button in
            if button is UIButton {
                button.removeFromSuperview()
            }
        }

        let buttonCount = aspectRatios.count
        let font = UIFont.systemFont(ofSize: 14)
        let padding: CGFloat = 9
        let margin = 2 * padding
        let buttonHeight: CGFloat = 20
        let colorImage = UIImage(color: UIColor(white: 0.5, alpha: 0.4),
                                 size: CGSize(width: 10, height: 10))
        let backgroundImage = colorImage.resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

        var x: CGFloat = margin
        for i in 0 ..< buttonCount {
            let button = UIButton(frame: CGRect.zero)
            button.tag = i
            button.backgroundColor = UIColor.clear
            button.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.setBackgroundImage(backgroundImage, for: .selected)
            button.layer.cornerRadius = buttonHeight / 2
            button.layer.masksToBounds = true
            button.titleLabel?.font = font
            button.addTarget(self, action: #selector(aspectRatioButtonPressed(_:)), for: .touchUpInside)

            let ar = aspectRatios[i]
            let title = ar.description
            let width = title.width(withFont: font) + padding * 2
            button.setTitle(title, for: .normal)
            button.frame = CGRect(x: x, y: 0, width: width, height: buttonHeight)
            x += width + padding

            scrollView.addSubview(button)
        }

        scrollView.height = buttonHeight
        scrollView.bottom = height - 8
        scrollView.contentSize = CGSize(width: x + padding, height: buttonHeight)
    }

    @objc
    func horizontalButtonPressed(_: UIButton) {
        if verticalButton.isSelected {
            horizontalButton.isSelected = true
            verticalButton.isSelected = false
            rotated = !rotated
            rotateAspectRatios()
        }
    }

    @objc
    func verticalButtonPressed(_: UIButton) {
        if horizontalButton.isSelected {
            horizontalButton.isSelected = false
            verticalButton.isSelected = true
            rotated = !rotated
            rotateAspectRatios()
        }
    }

    @objc
    func aspectRatioButtonPressed(_ sender: UIButton) {
        if !sender.isSelected {
            scrollView.subviews.forEach { view in
                if let button = view as? UIButton {
                    button.isSelected = false
                }
            }

            if sender.tag < aspectRatios.count {
                selectedAspectRatio = aspectRatios[sender.tag]
            } else {
                selectedAspectRatio = .freeForm
            }

            delegate?.aspectRatioPickerDidSelectedAspectRatio(selectedAspectRatio)
        }
    }
    
    func setRatio(ratio: AspectRatio){
        selectedAspectRatio = ratio
        delegate?.aspectRatioPickerDidSelectedAspectRatio(ratio)
    }

    func rotateAspectRatios() {
        let selected = selectedAspectRatio
        aspectRatios = aspectRatios.map { $0.rotated }
        selectedAspectRatio = selected.rotated
        delegate?.aspectRatioPickerDidSelectedAspectRatio(selectedAspectRatio)
    }

    func boxButton(size: CGSize) -> UIButton {
        let button = UIButton(frame: CGRect(origin: .zero, size: size))

        let normalColorImage = UIImage(color: UIColor(white: 0.14, alpha: 1),
                                       size: CGSize(width: 10, height: 10))
        let normalBackgroundImage = normalColorImage.resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

        let selectedColorImage = UIImage(color: UIColor(white: 0.56, alpha: 1),
                                         size: CGSize(width: 10, height: 10))
        let selectedBackgroundImage = selectedColorImage.resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))

        let checkmark = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)

        button.tintColor = .black
        button.layer.borderColor = UIColor(white: 0.56, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.setBackgroundImage(normalBackgroundImage, for: .normal)
        button.setBackgroundImage(selectedBackgroundImage, for: .selected)
        button.setImage(checkmark, for: .selected)
        return button
    }
}
