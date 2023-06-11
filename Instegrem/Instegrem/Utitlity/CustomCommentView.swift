//
//  CustomCommentView.swift
//  Instegrem
//
//  Created by Bao Long on 09/06/2023.
//

import Foundation
import UIKit

class CustomCommentView: UIView {
    
    var avatarImageView: UIImageView!
    var containerView: UIView!
    var commentButton: UIButton!
    var inputTextView: UITextView!
    var inputTextViewHeightConstraint: NSLayoutConstraint!
    init(avatarImageView: UIImageView, commentButton: UIButton, inputTextView: UITextView, inputTextViewHeightConstraint: NSLayoutConstraint) {
        self.avatarImageView = avatarImageView
        self.containerView = UIView()
        self.containerView.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.systemGray3.cgColor
        self.containerView.cornerRadius = 24
        self.containerView.clipsToBounds = true
        self.commentButton = commentButton
        self.inputTextView = inputTextView
        self.inputTextViewHeightConstraint = inputTextViewHeightConstraint
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        self.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(inputTextView)
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(commentButton)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            avatarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),
            
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            containerView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8),
            containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12),
            
            commentButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12),
            commentButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            commentButton.widthAnchor.constraint(equalToConstant: 34),
            
            inputTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 12),
            inputTextView.rightAnchor.constraint(equalTo: commentButton.leftAnchor, constant: -12),
            inputTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            inputTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            inputTextViewHeightConstraint
            
        ])
        
        addSeparator()
    }
    
    func addSeparator() {
        let sepa = UIView()
        self.addSubview(sepa)
        sepa.backgroundColor = .systemGray5
        sepa.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sepa.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            sepa.leftAnchor.constraint(equalTo: self.leftAnchor),
            sepa.rightAnchor.constraint(equalTo: self.rightAnchor),
            sepa.heightAnchor.constraint(equalToConstant: 0.7)
        ])
    }
}
