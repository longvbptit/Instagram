//
//  ProfileChangeDetailViewController.swift
//  Instegrem
//
//  Created by Bao Long on 30/05/2023.
//

import UIKit

class ProfileChangeDetailViewController: UIViewController {
    
    var navigationBar: CustomNavigationBar!
    var titleLabel: UILabel!
    var editTextView: UITextView!
    var dataUser: String!
    var firstRightButton: UIButton!
    weak var delegate: ProfileEditDetailDelegate!
    var indexInfo: Int!
    var textViewHeightConstraint: NSLayoutConstraint!
    var isBio: Bool = false
    let maxCharacterCount = 24
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
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .systemGray3
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        editTextView = UITextView()
        editTextView.returnKeyType = isBio ? .default : .done
        editTextView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        editTextView.text = dataUser
        editTextView.sizeToFit()
        editTextView.isScrollEnabled = false
        editTextView.isEditable = true
        view.addSubview(editTextView)
        editTextView.translatesAutoresizingMaskIntoConstraints = false
        editTextView.delegate = self
        editTextView.becomeFirstResponder()
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 6),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            
            editTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            editTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            editTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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
            
            bottomEdit.topAnchor.constraint(equalTo: editTextView.bottomAnchor, constant: 8),
            bottomEdit.widthAnchor.constraint(equalToConstant: view.frame.width),
            bottomEdit.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        delegate.didChangeInfo(index: indexInfo, info: editTextView.text)
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // allow line down with bio
        if text == "\n" && !isBio  {
            textView.resignFirstResponder()
            return false
        }
        // limit text in other
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > maxCharacterCount  && !isBio {
            return false // Prevent the text change
        }
        return true
    }
}

protocol ProfileEditDetailDelegate: NSObject {
    func didChangeInfo(index: Int, info: String)
}
