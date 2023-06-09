//
//  StatusTableViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 09/06/2023.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    var user: User!
    var time: Date!
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy 'lúc' HH:mm"
        return formatter
    }()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell() {
        avatarImageView.sd_setImage(with: URL(string: user.avatar))
        let nameAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold) ]
        let timeAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.lightGray ]
        let myString = NSMutableAttributedString(string: user.userName, attributes: nameAttribute )
        let attrString = NSAttributedString(string: " " + dateFormatter.string(from: time), attributes: timeAttribute)
        myString.append(attrString)
        userNameLabel.attributedText = myString
    }
    
}
