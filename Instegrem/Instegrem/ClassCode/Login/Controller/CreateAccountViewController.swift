//
//  CreateAccountViewController.swift
//  Instegrem
//
//  Created by Bao Long on 29/05/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import IQKeyboardManagerSwift

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var nameTextFiled: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        passwordTextField.isSecureTextEntry = true
        db = Firestore.firestore()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        loginButton.configuration?.showsActivityIndicator = true

        let newAccountInfo = CreateAccountInfo(email: emailTextField.text ?? "",
                                               password: passwordTextField.text ?? "",
                                               userName: userNameTextField.text ?? "",
                                               name: nameTextFiled.text ?? "")
        AuthService.createAccount(info: newAccountInfo, completion: { error in
            if let error = error {
                self.loginButton.configuration?.showsActivityIndicator = false
                print("DEBUG: \(error)")
                return
            }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(TabBarController())
            self.loginButton.configuration?.showsActivityIndicator = false
            
        })
    }

}
