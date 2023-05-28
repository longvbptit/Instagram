//
//  ProfileCreateTableViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 25/05/2023.
//

import UIKit

class ProfileCreateTableViewCell: UITableViewCell {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var createIcon = CreateIcon.reel
    var moreIcon = MoreIcon.setting
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
