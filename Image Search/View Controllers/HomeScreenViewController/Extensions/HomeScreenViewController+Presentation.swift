//
//  HomeScreenViewController.swift
//  Image Search
//
//  Created by Alok Singh on 13/09/18.
//  Copyright © 2018 T-System. All rights reserved.
//

import UIKit

extension HomeScreenViewController: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let ci = interactor else { return nil }
        return ci.transitionInProgress ? interactor : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let frame = self.selectedFrame else { return nil }
        guard let selectedImage = selectedImage else { return nil}
        
        switch operation {
        case .push:
            self.interactor = TSInteractor(attachTo: toVC)
            return TSCustomisedAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: true, originFrame: frame, image: selectedImage)
        default:
            return TSCustomisedAnimator(duration: TimeInterval(UINavigationControllerHideShowBarDuration), isPresenting: false, originFrame: frame, image: selectedImage)
        }
    }
}


