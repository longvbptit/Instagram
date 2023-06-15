//
//  ProfileBottomCollectionViewCell.swift
//  Instegrem
//
//  Created by Bao Long on 22/05/2023.
//

import UIKit

class ProfileBottomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    var isZooming: Bool = false
    var isPanning: Bool = false
    var originCenter = CGPoint()
    var cellTransform: CGAffineTransform!
    var pinchGesture: UIPinchGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    override func awakeFromNib() {
        super.awakeFromNib()
//        setUpGesture()
    }
    
    func setUpGesture() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        pinchGesture.delegate = self
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        var pinCenter: CGPoint!
        if gesture.state == .began {
            originCenter = view.center
            view.superview?.inputViewController?.tabBarController?.view.bringSubviewToFront(view)
            isZooming = true
        }
        
        if gesture.state == .changed && isZooming == true {
//            if gesture.numberOfTouches >= 2 {
//                let touch1 = gesture.location(ofTouch: 0, in: view)
//                let touch2 = gesture.location(ofTouch: 1, in: view)
//
//                pinCenter = CGPoint(x: (touch1.x + touch2.x) / 2 - view.bounds.midX, y: (touch1.y + touch2.y) / 2 - view.bounds.midY)
//
//                // Use the pinchCenter as needed
//            } else {
//                let touch1 = gesture.location(ofTouch: 0, in: view)
//                pinCenter = CGPoint(x: touch1.x - view.bounds.midX, y: touch1.y - view.bounds.midY)
//            }
            var newScale = gesture.scale
            if newScale < 1 {
                newScale = 1
            } else if newScale > 4 {
                newScale = 4
            }
            
            pinCenter = CGPoint(x: gesture.location(in: view).x - view.bounds.midX, y: gesture.location(in: view).y - view.bounds.midY)
            // var transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
            let transform = CGAffineTransform(translationX: -pinCenter.x, y: -pinCenter.y)
                                            .scaledBy(x: newScale, y: newScale)
                                            .translatedBy(x: pinCenter.x, y: pinCenter.y)
            UIView.animate(withDuration: 0.1, animations: {
                view.transform = transform
            })
            
        }
        
        if gesture.state == .cancelled || gesture.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                view.transform = .identity
            })
            isZooming = false
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        if gesture.state == .began && isZooming == true {
            // Store the original transform before applying the scale
            //            cellTransform = view.transform
            
            isPanning = true
        }
        
        if gesture.state == .changed && isZooming == true {
            let translation = gesture.translation(in: view)
            view.center = CGPoint(x: originCenter.x + translation.x, y: originCenter.y + translation.y)
        }
        
        if (gesture.state == .cancelled || gesture.state == .ended) && isPanning == true {
            UIView.animate(withDuration: 0.3, animations: {
                view.center = self.originCenter
            })
            isPanning = false
        }
        
    }
    
}

extension ProfileBottomCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pinchGesture && otherGestureRecognizer.view is UIScrollView {
            return false
        }
        if gestureRecognizer == panGesture && otherGestureRecognizer.view is UIScrollView {
            return true
        }
        return true
    }
}


public class ISImageView: UIImageView {
    
    @IBInspectable public var isInteractable: Bool = false {
        didSet {
            guard oldValue != isInteractable else { return }
            if isInteractable {
                backgroundColor = .systemGray3
                setupGesture()
                cellForTarget(superview: superview)?.clipsToBounds = false
                isUserInteractionEnabled = true
                pinchGesture.map { addGestureRecognizer($0) }
                panGesture.map { addGestureRecognizer($0) }
            } else {
                pinchGesture.map { removeGestureRecognizer($0) }
                panGesture.map { removeGestureRecognizer($0) }
            }
        }
    }
    
    private var isPinching = false
    private var pinchGesture: UIPinchGestureRecognizer?
    private var panGesture: UIPanGestureRecognizer?
    private var originalCenter: CGPoint?
    
    private func setupGesture() {
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(sender:)))
        pinchGesture?.delegate = self
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        panGesture?.delegate = self
    }
    
    private func cellForTarget(superview: UIView?) -> UIView? {
        guard superview != nil else {
            return nil
        }
        if superview is UITableViewCell || superview is UICollectionViewCell {
            return superview
        } else {
            return cellForTarget(superview: superview?.superview)
        }
    }
    
    @objc private func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            isPinching = sender.scale > 1
            layer.zPosition = 1
            cellForTarget(superview: superview)?.layer.zPosition = 1
        case .changed:
            guard let view = sender.view, isPinching else { return }
            let center = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                 y: sender.location(in: view).y - view.bounds.midY)
//            let transform = CGAffineTransform(translationX: center.x, y: center.y).scaledBy(x: sender.scale, y: sender.scale).translatedBy(x: -center.x, y: -center.y)
            view.transform = view.transform
                .translatedBy(x: center.x, y: center.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -center.x, y: -center.y)
            sender.scale = 1
        case .ended, .cancelled, .failed:
            reset()
        default:
            break
        }
    }
    
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began where isPinching:
            originalCenter = sender.view?.center
        case .changed where isPinching:
            guard let view = sender.view else { return }
            let translation = sender.translation(in: self)
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            sender.setTranslation(.zero, in: superview)
        default:
            break
        }
    }
    
    private func reset() {
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = .identity
            self.center = self.originalCenter ?? self.center
        }) { _ in
            self.isPinching = false
            self.layer.zPosition = 0
            self.cellForTarget(superview: self.superview)?.layer.zPosition = 0
        }
    }
}

extension ISImageView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pinchGesture && otherGestureRecognizer.view is UIScrollView {
            return false
        }
        if gestureRecognizer == panGesture && otherGestureRecognizer.view is UIScrollView {
            return true
        }
        return true
    }
}
