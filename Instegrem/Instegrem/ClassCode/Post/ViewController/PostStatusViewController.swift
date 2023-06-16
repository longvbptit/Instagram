//
//  PostStatusViewController.swift
//  Instegrem
//
//  Created by Bao Long on 02/06/2023.
//

import UIKit

class PostStatusViewController: UIViewController {
    
    //MARK: - Attribute
    var viewModel: HomeViewModel = HomeViewModel()
    var postImage: UIImage!
    var ratio: CGFloat!
    var navigationBar: CustomNavigationBar!
    var postImageView: UIImageView!
    var postStatusTextView: UITextView!
    var centerOriginImage: CGPoint!
    var tapImageGesture: UITapGestureRecognizer!
    var tapViewGesture: UITapGestureRecognizer!
    var rightButton: UIButton!
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addTapGesture()
    }
    
    deinit {
        print("DEBUG: DEINIT PostStatusViewController")
    }
    
    //MARK: - Configure UI
    func configUI() {
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "ic-back_small"), for: .normal)
        leftButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        
        rightButton = UIButton(type: .system)
        rightButton.setTitle("Chia sẻ", for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        rightButton.addTarget(self, action: #selector(postButtonTapped(_:)), for: .touchUpInside)
        
        let centerButton = UIButton()
        centerButton.setTitle("Bài viết mới", for: .normal)
        centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        centerButton.setTitleColor(.black, for: .normal)
        centerButton.isUserInteractionEnabled = false
        
        navigationBar = CustomNavigationBar(leftButtons: [leftButton], rightButtons: [rightButton], centerButton: centerButton)
        view.addSubview(navigationBar)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        postStatusTextView = UITextView()
        postStatusTextView.text = "Viết chú thích..."
        postStatusTextView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        postStatusTextView.textColor = UIColor.lightGray
        postStatusTextView.delegate = self
        postStatusTextView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.addSubview(postStatusTextView)
        postStatusTextView.translatesAutoresizingMaskIntoConstraints = false
        
        postImageView = UIImageView()
        postImageView.image = postImage
        postImageView.isUserInteractionEnabled = true
        view.addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 44),
            
            postImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 12),
            postImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
            postImageView.heightAnchor.constraint(equalToConstant: 64),
            postImageView.widthAnchor.constraint(equalToConstant: 64 * ratio),
            
            postStatusTextView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            postStatusTextView.leftAnchor.constraint(equalTo: postImageView.rightAnchor, constant: 8),
            postStatusTextView.rightAnchor.constraint(equalTo: view.rightAnchor),
            postStatusTextView.heightAnchor.constraint(equalToConstant: 88)
        ])
        addSeparatorNav()
    }
    
    //MARK: - @Objc
    @objc func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func postButtonTapped(_ sender: UIButton) {
        uploadPost()
    }
    
    @objc func addImageTapGesture(_ gesture: UITapGestureRecognizer) {
        let scale = view.bounds.width / postImageView.bounds.width
        let trans = CGAffineTransform(scaleX: scale, y: scale)
        view.endEditing(true)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, animations: {
            self.postImageView.transform = trans
            self.postImageView.center = self.view.center
            self.navigationBar.alpha = 0.3
            self.postStatusTextView.alpha = 0.3
            self.view.backgroundColor?.withAlphaComponent(0.3)
        }) { _ in
            self.postImageView.removeGestureRecognizer(self.tapImageGesture)
            self.view.addGestureRecognizer(self.tapViewGesture)
        }
    }
    
    @objc func addViewTapGesture(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, animations: {
            self.postImageView.transform = .identity
            self.postImageView.center = self.centerOriginImage
            self.navigationBar.alpha = 1
            self.postStatusTextView.alpha = 1
            self.view.backgroundColor?.withAlphaComponent(1)
        }) { _ in
            self.view.removeGestureRecognizer(self.tapViewGesture)
            self.postImageView.addGestureRecognizer(self.tapImageGesture)
        }
    }
    
    func addSeparatorNav() {
        let sepa = UIView()
        navigationBar.addSubview(sepa)
        sepa.backgroundColor = .gray
        sepa.alpha = 0.3
        sepa.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sepa.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -1),
            sepa.leftAnchor.constraint(equalTo: view.leftAnchor),
            sepa.rightAnchor.constraint(equalTo: view.rightAnchor),
            sepa.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func addTapGesture() {
        centerOriginImage = postImageView.center
        tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(addImageTapGesture(_:)))
        tapViewGesture = UITapGestureRecognizer(target: self, action: #selector(addViewTapGesture(_:)))
        postImageView.addGestureRecognizer(tapImageGesture)
    }
    
    func uploadPost() {
        rightButton.setTitle("", for: .normal)
        let config = UIButton.Configuration.plain()
        rightButton.configuration = config
        rightButton.configuration?.showsActivityIndicator = true
        
        let status = postStatusTextView.textColor == UIColor.lightGray ? "" : postStatusTextView.text ?? ""
        viewModel.uploadPost(status: status, image: postImage)
        viewModel.uploadPostCompletion = { [weak self] result in
            guard let strongSelf = self else { return }
            if !result {
                strongSelf.rightButton.setTitle("Chia sẻ", for: .normal)
                strongSelf.rightButton.configuration?.showsActivityIndicator = false
                print("Can't crate post.")
                return
            }
            NotificationCenter.default.post(name: Notification.Name("PostNewStatus"), object: nil)
            strongSelf.tabBarController?.selectedIndex = 0
            strongSelf.navigationController?.popViewController(animated: false)
        }
    }
    
}

extension PostStatusViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
           // create the updated text string
           let currentText:String = textView.text
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

           // If updated text view will be empty, add the placeholder
           // and set the cursor to the beginning of the text view
           if updatedText.isEmpty {

               textView.text = "Viết chú thích..."
               textView.textColor = UIColor.lightGray

               textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
           }

           // Else if the text view's placeholder is showing and the
           // length of the replacement string is greater than 0, set
           // the text color to black then set its text to the
           // replacement string
            else if textView.textColor == UIColor.lightGray && !text.isEmpty {
               textView.textColor = UIColor.black
               textView.text = text
           }

           // For every other case, the text should change with the usual
           // behavior...
           else {
               return true
           }

           // ...otherwise return false since the updates have already
           // been made
           return false
    }
    
}
