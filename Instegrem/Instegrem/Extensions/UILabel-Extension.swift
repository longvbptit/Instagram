//
//  UILabel-Extension.swift
//  Instegrem
//
//  Created by Bao Long on 31/05/2023.
//

import Foundation
import UIKit

extension UILabel{
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
    
    func set(image: String, with text: String) {
      let attachment = NSTextAttachment()
      attachment.image = UIImage(named: image)
      attachment.bounds = CGRect(x: 0, y: 0, width: 20, height: 10)
      let attachmentStr = NSAttributedString(attachment: attachment)

      let mutableAttributedString = NSMutableAttributedString()
      mutableAttributedString.append(attachmentStr)

        let textString = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
      mutableAttributedString.append(textString)

      self.attributedText = mutableAttributedString
    }
}
