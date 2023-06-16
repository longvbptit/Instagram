//
//  UserCollectionViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 14/06/2023.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOUTLET
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    //MARK: - Attribute
    var user: User!
    weak var delegate: FollowUserDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateData() {
        avatarImage.sd_setImage(with: URL(string: user.avatar))
        userNameLabel.text = user.userName
        nameLabel.text = user.name
    }
    
    func updateFollowButton() {
        switch(user.isFollowByCurrentUser) {
        case .currenUser:
            followButton.isHidden = true
        case .notFollowYet:
            followButton.isHidden = false
            UIView.performWithoutAnimation {
                followButton.setTitle("Theo dõi", for: .normal)
                followButton.setTitleColor(.white, for: .normal)
                followButton.backgroundColor = UIColor(red: 41/255, green: 153/255, blue: 251/255, alpha: 1)
                followButton.layoutIfNeeded()
            }
            
        case .followed:
            followButton.isHidden = false
            UIView.performWithoutAnimation {
                followButton.setTitle("Đang theo dõi", for: .normal)
                followButton.setTitleColor(.black, for: .normal)
                followButton.backgroundColor = .systemGray6
                followButton.layoutIfNeeded()
            }
            
        }
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        delegate.followUser(uid: user.uid, indexPath: indexPath)
    }
}
