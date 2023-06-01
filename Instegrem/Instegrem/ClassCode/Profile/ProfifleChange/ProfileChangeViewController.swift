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
    var user: User!
    var avt: UIImage!
    var rightButton: UIButton!
    weak var delegate: UpdateUserInfoDelegate!
    var pickerController: UIImagePickerController!
    var isChangeAvatar: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    deinit {
        print("DEBUG: DEINIT - ProfileChangeViewController deinit")
    }
    
    func configUI() {
        let leftButton = UIButton()
        leftButton.setTitle("Hủy", for: .normal)
        leftButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        leftButton.setTitleColor(.black, for: .normal)
        leftButton.addTarget(self, action: #selector(backButtonTappeed(_:)), for: .touchUpInside)
        
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Xong", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        rightButton.addTarget(self, action: #selector(doneButtonTappeed(_:)), for: .touchUpInside)
        
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
            navigationBarView.heightAnchor.constraint(equalToConstant: 44),
            
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
        dismiss(animated: true)
    }
    
    @objc func doneButtonTappeed(_ sender: UIButton) {
        rightButton.setTitle("", for: .normal)
        let config = UIButton.Configuration.plain()
        rightButton.configuration = config
        rightButton.configuration?.showsActivityIndicator = true
        if !isChangeAvatar {
            avt = nil
        }
        UserService.updateUser(user: user, avatar: avt, completion: { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.rightButton.setTitle("Xong", for: .normal)
                strongSelf.rightButton.configuration?.showsActivityIndicator = false
                print("Can't update user info. Error: \(error)")
                return
            }
            strongSelf.delegate.updateUserInfo(user: strongSelf.user ?? User(uid: "", dictionary: [:]), avatar: strongSelf.avt)
            strongSelf.dismiss(animated: true)
            
        })
        
    }

}

extension ProfileChangeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileChangeTopTableViewCell", for: indexPath) as! ProfileChangeTopTableViewCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.selectionStyle = .none
            cell.avatarButton.setImage(avt, for: .normal)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileChangeTableViewCell", for: indexPath) as! ProfileChangeTableViewCell
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0)
//            cell.tittleLabel.text = ProfileChange.allCases[indexPath.row - 1]
            let editCase = ProfileChange.allCases[indexPath.row - 1]
            cell.tittleLabel.text = editCase.rawValue

            switch(editCase) {
            case .name:
                cell.detailLabel.text = user.name
            case .user_name:
                cell.detailLabel.text = user.userName
            case .bio:
                cell.detailLabel.text = user.bio
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ProfileChangeTableViewCell {
            let vc = ProfileChangeDetailViewController()
            vc.title = cell.tittleLabel.text
            vc.dataUser = cell.detailLabel.text
            vc.indexInfo = indexPath.row
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

extension ProfileChangeViewController: ProfileEditDetailDelegate {
    func didChangeInfo(index: Int, info: String) {
        let editCase = ProfileChange.allCases[index - 1]
        switch(editCase) {
        case .name:
            user.name = info
        case .user_name:
            user.userName = info
        case .bio:
            user.bio = info
        }
        let indexPath = IndexPath(item: index, section: 0)
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension ProfileChangeViewController: ChangeAvatarDelegate {
    func showOption() {
        let vc = ProfileChangeAvatarViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.avatar = avt
        vc.completion = { [weak self] type in
            guard let strongSelf = self else { return }
//            guard UIImagePickerController.isSourceTypeAvailable(type) else {
//                return
//            }
            guard let type = type else {
                strongSelf.avt = UIImage(named: "ic-avatar_default")
                strongSelf.isChangeAvatar = true
                let indexPath = IndexPath(row: 0, section: 0)
                strongSelf.tableView.reloadRows(at: [indexPath], with: .automatic)
                return
            }
            strongSelf.pickerController = UIImagePickerController()
            strongSelf.pickerController.sourceType = type
            strongSelf.pickerController.delegate = strongSelf
            strongSelf.pickerController.allowsEditing = true
            strongSelf.pickerController.mediaTypes = ["public.image"]
            strongSelf.present(strongSelf.pickerController, animated: true)
        }
        present(vc, animated: false)
    }
}

extension ProfileChangeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.pickerController(picker, didSelect: nil)
//    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
//        self.pickerController(picker, didSelect: image)
        picker.dismiss(animated: true)
        avt = image
        isChangeAvatar = true
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

enum ProfileChange: String, CaseIterable {
    case name = "Tên"
    case user_name = "Tên người dùng"
    case bio = "Tiểu sử"
//    case link = "Liên kết"
}

protocol UpdateUserInfoDelegate: NSObject {
    func updateUserInfo(user: User, avatar: UIImage?)
}
