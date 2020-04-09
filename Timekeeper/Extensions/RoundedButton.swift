//
//  RoundedButton.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 03/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    private func setEnabledOrDisabledAnimation(button: UIButton, isEnabled: Bool) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        if isEnabled {
                            button.backgroundColor = UIColor.buttonColor
                            button.tintColor = UIColor.fontColor
                        } else {
                            button.backgroundColor = UIColor.darkGray
                            button.tintColor = UIColor.lightGray
                        }
        }, completion: nil)
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95), animatedColor: UIColor.trackColor, animatedTextColor: nil)
    }
    
    @objc private func animateUp(sender: UIButton) {
        sender.isEnabled ? animate(sender, transform: .identity, animatedColor: UIColor.buttonColor, animatedTextColor: nil) : animate(sender, transform: .identity, animatedColor: UIColor.darkGray, animatedTextColor: UIColor.lightGray)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform, animatedColor: UIColor, animatedTextColor: UIColor?) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut ],
                       animations: {
                        button.transform = transform
                        button.backgroundColor = animatedColor
                        
                        if let animTxtCl = animatedTextColor {
                            button.tintColor = animTxtCl
                        }
        }, completion: nil)
    }
    
    override open var isHighlighted : Bool {
        didSet {
            startAnimatingPressActions()
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
                isEnabled ? setEnabledOrDisabledAnimation(button: self, isEnabled: true) : setEnabledOrDisabledAnimation(button: self, isEnabled: false)
        }
    }
    
}
