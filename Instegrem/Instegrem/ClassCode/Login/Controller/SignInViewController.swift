//
//  SignInViewController.swift
//  Instegrem
//
//  Created by Bao Long on 28/05/2023.
//

import UIKit
import FirebaseAuth
import IQKeyboardManagerSwift
class SignInViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        passwordTextFiled.isSecureTextEntry = true
        emailTextField.text = "longvb@gmail.com"
        emailTextField.delegate = self
        passwordTextFiled.text = "123456"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {

        loginButton.configuration?.showsActivityIndicator = true
        Auth.auth().signIn(withEmail: emailTextField.text ?? "", password: passwordTextFiled.text ?? "") { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.loginButton.configuration?.showsActivityIndicator = false
                print("DEBUG: Sign-in false. Error: \(error)")
                return
            }
            
            print("DEBUG: \(String(describing: authResult?.user.uid))")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(TabBarController())
            strongSelf.loginButton.configuration?.showsActivityIndicator = false
            
        }
//        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(TabBarController())
    }
    
    
    
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("change to \(String(describing: textField.text))")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Calculate the resulting text if the change is applied
            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            
            // Perform any necessary actions with the updated text
            print("Text changed to: \(updatedText ?? "")")
            
            // Return true to allow the change, or false to reject it
            return true
        }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
