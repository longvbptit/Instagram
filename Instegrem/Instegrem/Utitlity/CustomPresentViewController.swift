//
//  CustomPresentViewController.swift
//  Instegrem
//
//  Created by Bao Long on 25/05/2023.
//

import Foundation
import UIKit

class CustomPresentViewController: UIViewController {
    
    // 1
    var completionHandler: (() -> Void)?
    
    var defaultHeight: CGFloat = 300
    // keep updated with new height
    var currentContainerHeight: CGFloat = 300
    var minHeight: CGFloat = 300
    var dismissByTap = false
    var panGesture: UIPanGestureRecognizer!
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    // 2
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    // 3. Dynamic container constraint
    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupPanGesture()
        setUpTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentContainer()
        animateShowDimmedView()
    }
    
    func setupView() {
        view.backgroundColor = .clear
    }
    
    func setupConstraints() {
        // 4. Add subviews
        currentContainerHeight = minHeight
        let topView = UIView()
        topView.backgroundColor = .gray
        topView.alpha = 0.5
        topView.cornerRadius = 3
        containerView.addSubview(topView)
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 5. Set static constraints
        NSLayoutConstraint.activate([
            
            //set constraint for top view
            topView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            topView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            topView.heightAnchor.constraint(equalToConstant: 6),
            topView.widthAnchor.constraint(equalToConstant: 48),
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // 6. Set container to default height
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: minHeight)
        // 7. Set bottom constant to 0
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: minHeight)
        // Activate constraints
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    func animatePresentContainer() {
        // Update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    func animateDismissView() {
        // hide main container view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        
        // hide blur view
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
            if self.dismissByTap {
                self.completionHandler?()
            }
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false) {
                if !self.dismissByTap {
                    self.completionHandler?()
                }
            }
        }
    }
    
    func setupPanGesture() {
        // add pan gesture recognizer to the view controller's view (the whole screen)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        // change to false to immediately listen on gesture movement
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        tapGesture.delaysTouchesBegan = false
        tapGesture.delaysTouchesEnded = false
        dimmedView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        dismissByTap = true
        animateDismissView()
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        var newHeight = currentContainerHeight + (-translation.y)

        let velocity = gesture.velocity(in: view).y
        
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            if newHeight < defaultHeight {
                // Keep updating the height constraint
                containerViewHeightConstraint?.constant = newHeight
                // refresh layout
                view.layoutIfNeeded()
            } else {
                newHeight = (newHeight - defaultHeight) / 10 + defaultHeight
                containerViewHeightConstraint?.constant = newHeight
            }
        case .ended:
            
            if velocity > 300 {
                animateDismissView()
            } else {
                if newHeight > minHeight {
                    animateContainerHeight(defaultHeight)
                } else {
                    animateContainerHeight(minHeight)
                }
            }
        default:
            break
        }
    }
    
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            // Update container height
            self.containerViewHeightConstraint?.constant = height
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
        // Save current height
        currentContainerHeight = height
    }
}
