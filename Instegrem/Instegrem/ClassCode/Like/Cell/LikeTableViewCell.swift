//
//  LikeTableViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 08/06/2023.
//

import UIKit

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    var user: User! {
        didSet {
//            followButton.isHidden = true
            avatarImage.sd_setImage(with: URL(string: user.avatar))
            userNameLabel.text = user.userName
            nameLabel.text = user.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell() {
        followButton.isHidden = true
        avatarImage.sd_setImage(with: URL(string: user.avatar))
        userNameLabel.text = user.userName
        nameLabel.text = user.name
    }
}
