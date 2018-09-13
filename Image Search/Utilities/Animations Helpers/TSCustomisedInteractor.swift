//
//  ViewController.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//


import UIKit

class TSInteractor : UIPercentDrivenInteractiveTransition {
    
    var navigationController : UINavigationController
    var shouldCompleteTransition = false
    var transitionInProgress = false
    init?(attachTo viewController : UIViewController) {
        if let nav = viewController.navigationController {
            self.navigationController = nav
            super.init()
            setupBackGesture(view: viewController.view)
        } else {
            return nil
        }
    }
    
    internal func setupBackGesture(view : UIView) {
        let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
        swipeBackGesture.edges = .left
        view.addGestureRecognizer(swipeBackGesture)
    }
    
    @objc internal func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: gesture.view?.superview)
        let progress = viewTranslation.x / self.navigationController.view.frame.width

        switch gesture.state {
        case .began:
            transitionInProgress = true
            navigationController.popViewController(animated: true)
            break
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            break
        case .cancelled:
            transitionInProgress = false
            cancel()
            break
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
        default:
            return
        }
    }
    
}
