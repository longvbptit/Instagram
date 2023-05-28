//
//  ProfileCreateViewController.swift
//  Instegrem
//
//  Created by Bao Long on 25/05/2023.
//

import UIKit

class ProfileMoreViewController: CustomPresentViewController {

    var tableView: UITableView!
    var bottomDistance: CGFloat = 100
    override func viewDidLoad() {
        defaultHeight = CGFloat(MoreIcon.allCases.count * 72) + bottomDistance
        minHeight = CGFloat(72*3 + 14)

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

extension ProfileMoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoreIcon.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCreateTableViewCell", for: indexPath) as! ProfileCreateTableViewCell
        cell.moreIcon = MoreIcon.allCases[indexPath.row]
        cell.iconImage.image = UIImage(named: cell.moreIcon.image())
        cell.descriptionLabel.text = cell.moreIcon.rawValue
        cell.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.animateDismissView()
    }
    
    
}

enum MoreIcon: String, CaseIterable {
    case setting = "Cài đặt"
    case activity = "Hoạt động của bạn"
    case archives = "Kho lưu trữ"
    case qr = "Mã QR"
    case saved = "Đã lưu"
    case payment = "Đơn đặt hàng và thanh toán"
    case best_friend = "Bạn thân"
    case liked = "Yêu thích"
    
    func image() -> String {
        switch self {
        case .setting:
            return "ic-setting"
        case .activity:
            return "ic-activity"
        case .archives:
            return "ic-archives"
        case .qr:
            return "ic-qr"
        case .saved:
            return "ic-saved"
        case .payment:
            return "ic-payment"
        case .best_friend:
            return "ic-best_friend"
        case .liked:
            return "ic-liked"
        }
    }
}
