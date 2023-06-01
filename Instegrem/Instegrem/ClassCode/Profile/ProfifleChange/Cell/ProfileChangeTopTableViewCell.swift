//
//  ProfileChangeTopTableViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 26/05/2023.
//

import UIKit

class ProfileChangeTopTableViewCell: UITableViewCell {
//height 16*3 + 80 + 30
    @IBOutlet weak var changeAvatarButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    weak var delegate: ChangeAvatarDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarButton.addTarget(self, action: #selector(changeAvatarButtonTapped(_:)), for: .touchUpInside)
        changeAvatarButton.addTarget(self, action: #selector(changeAvatarButtonTapped(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func changeAvatarButtonTapped(_ sender: UIButton) {
        delegate.showOption()
    }
    
}

protocol ChangeAvatarDelegate: NSObject {
    func showOption()
}
