//
//  ReelsViewController.swift
//  Instegrem
//
//  Created by Bao Long on 14/06/2023.
//

import UIKit

class ReelsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        navigationController?.navigationBar.prefersLargeTitles = true
    
        self.navigationItem.title = "Reels"

    }
    
    deinit {
        print("DEBUG: DEINIT ReelsViewController")
    }
    
    func configUI() {
        let notilabel = UILabel()
        notilabel.text = "This feature is under development..."
        notilabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        notilabel.numberOfLines = 0
        notilabel.textAlignment = .center
        view.addSubview(notilabel)
        notilabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notilabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notilabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            notilabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 64)
        ])
    }

}
