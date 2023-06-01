//
//  ProfileChangeAvatarViewController.swift
//  Instegrem
//
//  Created by Bao Long on 31/05/2023.
//

import UIKit

class ProfileChangeAvatarViewController: CustomPresentViewController {
    
    var avatar: UIImage!
    var avatarImageView: UIImageView!
    var tableView: UITableView!
    var completion: ((UIImagePickerController.SourceType?) -> Void)?
    override func viewDidLoad() {
        defaultHeight = CGFloat(14 + 12 + 48 + 24 + 56 * ChangeAvatarIcon.allCases.count + 50)
        minHeight = defaultHeight
        super.viewDidLoad()
        configUI()
    }
    
    deinit {
        print("DEBUG: DEINIT - ProfileChangeAvatarViewController deinit")
    }
    
    func configUI() {
//        pickerController = UIImagePickerController()
        
        avatarImageView = UIImageView()
        avatarImageView.image = avatar
        avatarImageView.contentMode = .scaleToFill
        avatarImageView.cornerRadius = 24
        avatarImageView.clipsToBounds = true
        containerView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfileCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileCreateTableViewCell")
        tableView.isScrollEnabled = false
        containerView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let sepaView = UIView()
        sepaView.backgroundColor = .darkGray
        containerView.addSubview(sepaView)
        sepaView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12 + 6 + 8),
            avatarImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 48),
            avatarImageView.heightAnchor.constraint(equalToConstant: 48),
            
            tableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 24),
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            sepaView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            sepaView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sepaView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            sepaView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    
    func customDismissForChangeAvatar(for type: UIImagePickerController.SourceType) {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            
            self.dismiss(animated: false) {
                self.completion?(type)
            }
        }
    }
    
    func customDismissForRemoveAvatar() {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            
            self.dismiss(animated: false) {
                self.completion?(nil)
            }
        }
    }

}

extension ProfileChangeAvatarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ChangeAvatarIcon.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCreateTableViewCell", for: indexPath) as! ProfileCreateTableViewCell
        let caseOfCell = ChangeAvatarIcon.allCases[indexPath.row]
        cell.iconImage.image = UIImage(named: caseOfCell.image)
        cell.descriptionLabel.text = caseOfCell.rawValue
        cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.width/2, bottom: 0, right: tableView.frame.width/2)
        if indexPath.row == ChangeAvatarIcon.allCases.count - 1 {
            cell.descriptionLabel.textColor = .red
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == ChangeAvatarIcon.allCases.count - 1 {
            customDismissForRemoveAvatar()
        } else {
            customDismissForChangeAvatar(for: ChangeAvatarIcon.allCases[indexPath.row].sourceType)
        }
        
    }
    
}

enum ChangeAvatarIcon: String, CaseIterable {
    case takePhoto = "Chụp ảnh"
    case cameraRoll = "Ảnh đã chụp"
    case library = "Chọn ảnh trong thư viện"
    case removeAvatar = "Gỡ ảnh hiện tại"
    var image: String {
        switch self {
        case .takePhoto:
            return "ic-camera"
        case .cameraRoll:
            return "ic-camera_black"
        case .library:
            return "ic-library"
        case .removeAvatar:
            return "ic-trash"
        }
    }
    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .takePhoto:
            return .camera
        case .cameraRoll:
            return .savedPhotosAlbum
        case .library:
            return .photoLibrary
        default:
            return .camera
        }
    }
}
