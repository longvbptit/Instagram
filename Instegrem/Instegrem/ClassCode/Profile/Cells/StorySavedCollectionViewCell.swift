//
//  StorySavedCollectionViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 24/05/2023.
//

import UIKit

class StorySavedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addStoryImage: UIImageView!
    @IBOutlet weak var widthAddStory: NSLayoutConstraint!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var storyView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
