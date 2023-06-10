//
//  CommentViewController.swift
//  Instegrem
//
//  Created by Bao Long on 09/06/2023.
//

import UIKit

class CommentViewController: UIViewController {
    
    var post: Post!
    var user: User!
    var indexPath: IndexPath!
    var comments: [Comment] = []
    var navigationBar: CustomNavigationBar!
    var tableView: UITableView!
    var commentView: CustomCommentView!
    var commentViewBottomAnchor: NSLayoutConstraint!
    var inputTextView: UITextView!
    var inputTextViewHeightConstraint: NSLayoutConstraint!
    var commentButton: UIButton!
    var placeholder: String!
    weak var delegate: CommentPostDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        getCurrentUser()
        configUI()
        getComments()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        inputTextView.becomeFirstResponder()
    }
    
    deinit {
        print("DEBUG: DEINIT CommentViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
    func getCurrentUser() {
        let tabbar = tabBarController as! TabBarController
        user = tabbar.user
    }
    
    func configUI() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "ic-back_small"), for: .normal)
        leftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()
        centerButton.setTitle("Bình luận", for: .normal)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        centerButton.setTitleColor(.black, for: .normal)
        centerButton.isUserInteractionEnabled = false
        
        navigationBar = CustomNavigationBar(leftButtons: [leftButton], centerButton: centerButton)
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let avatarImageView = UIImageView()
        avatarImageView.sd_setImage(with: URL(string: user.avatar))
        avatarImageView.cornerRadius = 24
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleToFill
        
        inputTextView = UITextView()
        inputTextView.delegate = self
        //        inputTextView.text = "Viết comment"
        inputTextView.textColor = .black
        inputTextView.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        inputTextView.sizeToFit()
        inputTextView.isScrollEnabled = true
        inputTextView.isEditable = true
        commentButton = UIButton(type: .system)
        commentButton.addTarget(self, action: #selector(commentButtonTapped(_:)), for: .touchUpInside)
        commentButton.setTitle("Đăng", for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        commentButton.isEnabled = false
        
        inputTextViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: 32)
        
        commentView = CustomCommentView(avatarImageView: avatarImageView, commentButton: commentButton, inputTextView: inputTextView, inputTextViewHeightConstraint: inputTextViewHeightConstraint)
        view.addSubview(commentView)
        commentView.translatesAutoresizingMaskIntoConstraints = false
        
        commentViewBottomAnchor = commentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            commentViewBottomAnchor,
            commentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            commentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentView.topAnchor)
            
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "StatusTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusTableViewCell")
        
        addSeparatorNav()
    }
    
    func addSeparatorNav() {
        let sepa = UIView()
        view.addSubview(sepa)
        sepa.backgroundColor = .systemGray5
        sepa.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sepa.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 0),
            sepa.leftAnchor.constraint(equalTo: view.leftAnchor),
            sepa.rightAnchor.constraint(equalTo: view.rightAnchor),
            sepa.heightAnchor.constraint(equalToConstant: 0.7)
        ])
    }
    
    func getComments() {
        HomeService.getCommentPost(idPost: post.idPost, completion: { [weak self] comments, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.comments = comments.sorted { $0.time > $1.time }
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func commentButtonTapped(_ sender: UIButton) {
        HomeService.addComment(idPost: post.idPost, comment: inputTextView.text, completion: { [weak self] comment, time, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            strongSelf.inputTextView.text = ""
            strongSelf.commentButton.isEnabled = false
            let newComment = Comment(user: strongSelf.user, time: time, comment: comment)
            strongSelf.comments.insert(newComment, at: 0)
            let indexPath = IndexPath(row: 1, section: 0)
            strongSelf.tableView.insertRows(at: [indexPath], with: .automatic)
            strongSelf.delegate.updateNumberOfCommentButton(indexPath: strongSelf.indexPath,
                                                            numberOfComment: strongSelf.comments.count)
        })
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        UIView.animate(withDuration: duration, animations: {
            self.commentViewBottomAnchor.isActive = false
            self.commentViewBottomAnchor = self.commentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardSize.height)
            self.commentViewBottomAnchor.isActive = true
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        UIView.animate(withDuration: duration, animations: {
            self.commentViewBottomAnchor.isActive = false
            self.commentViewBottomAnchor = self.commentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            self.commentViewBottomAnchor.isActive = true
            self.view.layoutIfNeeded()
        })
    }
    
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if post.status == "" && indexPath.row == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatusTableViewCell", for: indexPath) as! StatusTableViewCell
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.user = post.user
            cell.statusLabel.text = "\(post.status)"
            cell.time = post.time
            cell.setUpCell()
            
        } else {
            cell.user = comments[indexPath.row - 1].user
            cell.statusLabel.text = comments[indexPath.row - 1].comment
            cell.time = comments[indexPath.row - 1].time
            cell.setUpCell()
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.width/2, bottom: 0, right: tableView.frame.width/2)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ProfileViewController()
        vc.isOrigin = false
        vc.user = indexPath.row == 0 ? post.user : comments[indexPath.row - 1].user
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CommentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxNumberOfLines = 4
        let lineHeight = textView.font?.lineHeight ?? 0
        let contentHeight = textView.contentSize.height
        let numberOfLines = Int(contentHeight / lineHeight)
        if numberOfLines <= maxNumberOfLines {
            inputTextViewHeightConstraint.constant = contentHeight
            view.layoutIfNeeded()
        }
        let comment = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        commentButton.isEnabled = comment != ""
        placeholder = textView.text
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Thêm bình luận..."
            textView.textColor = UIColor.lightGray
            placeholder = ""
        } else {
            placeholder = textView.text
        }
    }
    
}

protocol CommentPostDelegate: NSObject {
    func updateNumberOfCommentButton(indexPath: IndexPath, numberOfComment: Int)
}
