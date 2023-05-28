//
//  HomeViewController.swift
//  Instegrem
//
//  Created by Bao Long on 19/05/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var commentTextFiled: UITextField!
    var topAnchor: NSLayoutConstraint!
    var customNav: CustomNavigationBar!
    @IBOutlet weak var testView: UIView!
    private var initialCenter: CGPoint = .zero
    var centerNav: CGPoint = .zero
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testView.translatesAutoresizingMaskIntoConstraints = false
        topAnchor = testView.topAnchor.constraint(equalTo: commentTextFiled.bottomAnchor, constant: 12)
        NSLayoutConstraint.activate([
            testView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            testView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8 ),
            testView.heightAnchor.constraint(equalToConstant: 500),
            topAnchor
        ])
        
        let imageView: UIImageView = UIImageView(image: UIImage(named: "avt"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        testView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: testView.topAnchor, constant: 10),
            imageView.leftAnchor.constraint(equalTo: testView.leftAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        let label = UILabel()
        label.backgroundColor = UIColor.red
        label.text = "ahhiiiiiiiiii"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        testView.addSubview(label)
        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: testView.rightAnchor, constant: -100),
            label.topAnchor.constraint(equalTo: testView.topAnchor, constant: 100),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20)
        ])
        
        setupNav()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //        let vc = ProfileViewController()
        //        navigationController?.pushViewController(vc, animated: true)
    }
    func setUpTextFiled() {
        // Set the input mode to a keyboard that supports emoji
        commentTextFiled.keyboardType = .asciiCapable
        commentTextFiled.keyboardAppearance = .dark
        
        // Show the emoji keyboard by setting the text input mode
        if let emojiInputMode = UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == "emoji" }) {
            //            commentTextFiled.textInputMode = emojiInputMode
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        centerNav = customNav.center
    }
    
    func setupNav() {
        let firstLeftButton = UIButton()
        firstLeftButton.setTitle("bao_longgg", for: .normal)
        firstLeftButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        firstLeftButton.setTitleColor(UIColor.black, for: .normal)
        
        let firstRightButton = UIButton()
        firstRightButton.setImage(UIImage(named: "ic-more"), for: .normal)
        
        let secondRightButton = UIButton()
        secondRightButton.setImage(UIImage(named: "ic-create"), for: .normal)
        customNav = CustomNavigationBar(leftButtons: [firstLeftButton], rightButtons: [firstRightButton, secondRightButton], spacingRightButton: 24)
        customNav.backgroundColor = UIColor.white
        testView.addSubview(customNav)
        
        customNav.translatesAutoresizingMaskIntoConstraints = false
        customNav.backgroundColor = .yellow
        NSLayoutConstraint.activate([
            customNav.leftAnchor.constraint(equalTo: testView.leftAnchor),
            customNav.centerXAnchor.constraint(equalTo: testView.centerXAnchor),
            customNav.topAnchor.constraint(equalTo: testView.topAnchor, constant: 150)
        ])
        
        let panGestture = UIPanGestureRecognizer(target: self, action: #selector(handlePan4(_:)))
        customNav.addGestureRecognizer(panGestture)
        
    }
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        //        print(pan.location(in: view))
        let velocity = pan.velocity(in: view)
        switch pan.state {
        case .began:
            initialCenter = customNav.center
        case .changed:
            let translation = pan.translation(in: customNav.superview)
            //            print(translation)
            let newCenter = CGPoint(x: initialCenter.x + translation.x,
                                    y: initialCenter.y + translation.y)
            
            let restrictedArea = customNav.superview!.frame
            
            
            if restrictedArea.contains(newCenter) {
                //                customNav.center = newCenter
            }
            customNav.center = newCenter
            //            pan.setTranslation(.zero, in: view)
            //
        case .ended,
                .cancelled:
            if abs(velocity.y) > 100 {
                print("ahihi")
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
                    self.customNav.center = self.centerNav
                    //                    print(self.view.center)
                }
            }
            
            print(pan.translation(in: view))
            print(pan.translation(in: testView))
            print(pan.translation(in: customNav))
        default:
            break
        }
        
        //        pan.setTranslation(.zero, in: customNav.superview)
    }
    
    @objc func handlePan2(_ pan: UIPanGestureRecognizer) {
        let trans = pan.translation(in: customNav)
        print("trans2: \(trans)")
        let cent = customNav.center
        let newCent = CGPoint(x: cent.x + trans.x, y: cent.y + trans.y)
        customNav.center = newCent
        
        //        customNav.center = centerNav
        pan.setTranslation(CGPoint.zero, in: view)
    }
    
    @objc func handlePan3(_ gesture: UIPanGestureRecognizer) {
        // Handle the pan gesture here
        let translation = gesture.translation(in: testView)
        
        // Do something with the translation, such as updating the position of a view
        let newX = centerNav.x + translation.x
        let newY = centerNav.y + translation.y
        customNav.center = CGPoint(x: newX, y: newY)
        
        if gesture.state == .ended {
            customNav.center = centerNav
        }
        // Reset the translation to zero so that it starts from the initial position in the next callback
        //        gesture.setTranslation(CGPoint.zero, in: customNav)
    }
    
    @objc func handlePan4(_ pan: UIPanGestureRecognizer) {
        var touchPositionInSuperView = pan.location(in: testView)
        var touchPositionInView = pan.location(in: customNav)
        touchPositionInSuperView.y = touchPositionInSuperView.y - touchPositionInView.y
        //        print("ahihi\(touchPosition)")
        print(testView.frame)
        let trans = pan.translation(in: customNav)
        if touchPositionInSuperView.y <= self.testView.frame.height - self.customNav.frame.height && touchPositionInSuperView.y >= 0{
            print("trans2: \(trans)")
            let cent = customNav.center
            let newCent = CGPoint(x: cent.x, y: cent.y + trans.y)
            customNav.center = newCent
            
            //        customNav.center = centerNav
            pan.setTranslation(CGPoint.zero, in: view)
        } else if (touchPositionInSuperView.y < 0 && trans.y > 0) || (touchPositionInSuperView.y > self.testView.frame.height - self.customNav.frame.height && trans.y < 0) {
            print("trans2: \(trans)")
            let cent = customNav.center
            let newCent = CGPoint(x: cent.x, y: cent.y + trans.y)
            customNav.center = newCent
            
            //        customNav.center = centerNav
            pan.setTranslation(CGPoint.zero, in: view)
            
        } else {
            pan.setTranslation(CGPoint.zero, in: view)
        }
        
        
    }
    
}
