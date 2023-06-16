//
//  LoginViewController.swift
//  Instegrem
//
//  Created by Bao Long on 28/05/2023.
//

import UIKit
import IQKeyboardManagerSwift
class LoginViewController: UIViewController {

    //MARK: - IBOUTLET
    @IBOutlet weak var createAccButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccButton.addTarget(self, action: #selector(createAccButtonTapped(_:)), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    //MARK: - @Objc
    @objc func createAccButtonTapped(_ sender: UIButton) {
        let vc = CreateAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


}
