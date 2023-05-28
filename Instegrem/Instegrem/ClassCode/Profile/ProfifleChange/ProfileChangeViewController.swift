//
//  ProfileChangeViewController.swift
//  Instegrem
//
//  Created by Bao Long on 26/05/2023.
//

import UIKit

class ProfileChangeViewController: UIViewController {

    var navigationBarView: CustomNavigationBar!
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        let leftButton = UIButton()
        leftButton.setTitle("Hủy", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.addTarget(self, action: #selector(backButtonTappeed(_:)), for: .touchUpInside)
        
        let rightButton = UIButton(type: .system)
        rightButton.setTitle("Xong", for: .normal)
//        rightButton.setTitleColor(.black, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        rightButton.addTarget(self, action: #selector(backButtonTappeed(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()
        centerButton.setTitle("Chỉnh sửa trang cá nhân", for: .normal)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        centerButton.setTitleColor(.black, for: .normal)
        centerButton.isUserInteractionEnabled = false
        
        navigationBarView = CustomNavigationBar(leftButtons: [leftButton], rightButtons: [rightButton], centerButton: centerButton)
        tableView = UITableView()
        view.addSubview(navigationBarView)
        view.addSubview(tableView)
        
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
//            navigationBarView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
//            navigationBarView.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(UINib(nibName: "ProfileChangeTopTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileChangeTopTableViewCell")
        tableView.register(UINib(nibName: "ProfileChangeTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileChangeTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        addSeparatorNav()
    }
    
    func addSeparatorNav() {
        let sepa = UIView()
        view.addSubview(sepa)
        sepa.backgroundColor = .gray
        sepa.alpha = 0.3
        sepa.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sepa.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: -1),
            sepa.leftAnchor.constraint(equalTo: view.leftAnchor),
            sepa.rightAnchor.constraint(equalTo: view.rightAnchor),
            sepa.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc func backButtonTappeed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

}

extension ProfileChangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileChangeTopTableViewCell", for: indexPath) as! ProfileChangeTopTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileChangeTableViewCell", for: indexPath) as! ProfileChangeTableViewCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0)
            cell.tittleLabel.text = ProfileChange.allCases[indexPath.row - 1].rawValue
            return cell
        }
        
    }
    
    
}

enum ProfileChange: String, CaseIterable {
    case name = "Tên"
    case user_name = "Tên người dùng"
    case history = "Tiểu sử"
    case link = "Liên kết"
}
