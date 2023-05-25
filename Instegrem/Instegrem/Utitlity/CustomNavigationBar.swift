//
//  CustomNavigationBar.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import Foundation
import UIKit

class CustomNavigationBar: UIView {
    
    var leftButtons: [UIButton]!
    var rightButtons: [UIButton]!
    var centerButton: UIButton!
    var spacingLeftButton: CGFloat!
    var spacingRightButton: CGFloat!
    
    init(leftButtons: [UIButton] = [], spacingLeftButton: Float = 0, rightButtons: [UIButton] = [], spacingRightButton: Float = 0, centerButton: UIButton = UIButton()) {
        
        self.leftButtons = leftButtons
        self.spacingLeftButton = CGFloat(spacingLeftButton)
        self.rightButtons = rightButtons
        self.spacingRightButton = CGFloat(spacingRightButton)
        self.centerButton = centerButton
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        
        for (index, leftButton) in leftButtons.enumerated() {
            if index == 0 {
                self.addSubview(leftButton)
                leftButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    leftButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12),
                    leftButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                    leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
                ])
            } else {
                self.addSubview(leftButton)
                leftButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    leftButton.leftAnchor.constraint(equalTo: leftButtons[index - 1].rightAnchor, constant: spacingLeftButton),
                    leftButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                    leftButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
                ])
            }
        }
        
        for (index, rightButton) in rightButtons.enumerated() {
            if index == 0 {
                self.addSubview(rightButton)
                rightButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    rightButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
                    rightButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                    rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
                ])
            } else {
                self.addSubview(rightButton)
                rightButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    rightButton.rightAnchor.constraint(equalTo: rightButtons[index - 1].leftAnchor, constant: spacingRightButton * -1),
                    rightButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                    rightButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
                ])
            }
        }
        
        self.addSubview(centerButton)
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
   
}
