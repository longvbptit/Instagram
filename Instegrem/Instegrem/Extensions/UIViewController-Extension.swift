//
//  UIViewController-Extension.swift
//  Instegrem
//
//  Created by Bao Long on 07/06/2023.
//

import Foundation
import UIKit

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    //        // Check if the tapped view is a button
    //        if let tappedView = sender.view, tappedView is UIButton {
    //            return
    //        }
    //
    //        view.endEditing(true)
    //    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if view.hitTest(location, with: nil) is UIButton {
            // Tapped view is a button, do not dismiss keyboard
            return
        }
        
        view.endEditing(true)
    }
}
