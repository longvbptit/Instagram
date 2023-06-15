//
//  ProfileCreateViewController.swift
//  Instegrem
//
//  Created by Bao Long on 25/05/2023.
//

import UIKit

class ProfileCreateViewController: CustomPresentViewController {

    var tableView: UITableView!
    var bottomDistance: CGFloat = 100
    override func viewDidLoad() {
        defaultHeight = CGFloat((CreateIcon.allCases.count + 1) * 56) + bottomDistance
        minHeight = 56*4 + 14
        super.viewDidLoad()
        layoutTableView()
        // Do any additional setup after loading the view.
    }
    
    func layoutTableView() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "ProfileCreateTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileCreateTableViewCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])
        tableView.addGestureRecognizer(panGesture)
    }


}

extension ProfileCreateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateIcon.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCreateTableViewCell", for: indexPath) as! ProfileCreateTableViewCell
        if indexPath.row == 0 {
            cell.iconImage.isHidden = true
            cell.topLabel.isHidden = false
            cell.descriptionLabel.isHidden = true
            cell.topLabel.text = "Tạo"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            cell.createIcon = CreateIcon.allCases[indexPath.row - 1]
            cell.iconImage.image = UIImage(named: cell.createIcon.image())
            cell.descriptionLabel.text = cell.createIcon.rawValue
            cell.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            self.animateDismissView()
        }
    }
    
    
}
enum CreateIcon: String, CaseIterable {
    case reel = "Thước phim"
    case post = "Bài viết"
    case story = "Tin"
    case saved_story = "Tin nổi bật"
    case live = "Trực tiếp"
    case guide = "Hướng dẫn"
    
    func image() -> String {
        switch self {
        case .reel:
            return "ic-reels"
        case .post:
            return "ic-posts"
        case .story:
            return "ic-story"
        case .saved_story:
            return "ic-saved_story"
        case .live:
            return "ic-live"
        case .guide:
            return "ic-guide"
        }
    }
}
