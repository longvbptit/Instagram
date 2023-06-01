//
//  ProfileChangeDetailViewController.swift
//  Instegrem
//
//  Created by Bao Long on 30/05/2023.
//

import UIKit

class ProfileChangeDetailViewController: UIViewController {
    
    var navigationBar: CustomNavigationBar!
    var titleTextView: UILabel!
    var editTextField: UITextView!
    var dataUser: String!
    var firstRightButton: UIButton!
    weak var delegate: ProfileEditDetailDelegate!
    var indexInfo: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("DEBUG: DEINIT - ProfileChangeDetailViewController deinit")
    }
    
    func configUI() {
        let firstLeftButton = UIButton(type: .system)
        firstLeftButton.setImage(UIImage(named: "ic-cancel_small")?.withRenderingMode(.alwaysOriginal), for: .normal)
        firstLeftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton(type: .system)
        centerButton.setTitle(title, for: .normal)
        centerButton.setTitleColor(.black, for: .normal)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        
        firstRightButton = UIButton(type: .system)
        firstRightButton.setTitle("Xong", for: .normal)
        firstRightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        firstRightButton.setTitleColor(.systemGray3, for: .disabled)
        firstRightButton.isEnabled = false
        firstRightButton.addTarget(self, action: #selector(doneButtonTapped  (_:)), for: .touchUpInside)
        
        navigationBar = CustomNavigationBar(leftButtons: [firstLeftButton], rightButtons: [firstRightButton], centerButton: centerButton)
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextView = UILabel()
        titleTextView.text = title
        titleTextView.textColor = .systemGray3
        titleTextView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.addSubview(titleTextView)
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        
        editTextField = UITextView()
        editTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        editTextField.text = dataUser
        editTextField.sizeToFit()
        editTextField.isScrollEnabled = false
        //        editTextField.clearButtonMode = .whileEditing
        editTextField.isEditable = true
        view.addSubview(editTextField)
        editTextField.translatesAutoresizingMaskIntoConstraints = false
        editTextField.delegate = self
        editTextField.becomeFirstResponder()
        
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            titleTextView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 6),
            titleTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            editTextField.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 6),
            editTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            editTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let bottomNav = UIView()
        bottomNav.backgroundColor = .systemGray5
        view.addSubview(bottomNav)
        bottomNav.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomEdit = UIView()
        bottomEdit.backgroundColor = .systemGray5
        view.addSubview(bottomEdit)
        bottomEdit.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomNav.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            bottomNav.widthAnchor.constraint(equalToConstant:view.frame.width),
            bottomNav.heightAnchor.constraint(equalToConstant: 1),
            
            bottomEdit.topAnchor.constraint(equalTo: editTextField.bottomAnchor, constant: 8),
            bottomEdit.widthAnchor.constraint(equalToConstant: view.frame.width),
            bottomEdit.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        delegate.didChangeInfo(index: indexInfo, info: editTextField.text)
    }
    
}

extension ProfileChangeDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != dataUser {
            firstRightButton.isEnabled = true
        } else {
            firstRightButton.isEnabled = false
        }
    }
}

protocol ProfileEditDetailDelegate: NSObject {
    func didChangeInfo(index: Int, info: String)
}
