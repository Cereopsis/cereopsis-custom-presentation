//
//  CustomAnimation.swift
//  Boardwalk
//
//  Created by John Walker on 27/07/2016.
//  Copyright © 2016 John Walker. All rights reserved.
//

import UIKit

extension CGRect {
    func translate(point: CGPoint) -> CGRect {
        return CGRect(x: minX + point.x, y: minY + point.y, width: width, height: height)
    }
}

protocol CustomTransitionAnimationDelegate: class {
    func animationDidFinish(context: CustomTransitionAnimation, presenting: Bool)
}

class CustomTransitionAnimation: NSObject {
    
    weak var delegate: CustomTransitionAnimationDelegate?
    
    init(delegate: CustomTransitionAnimationDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    deinit {
        print("we're going down...")
    }
}

extension CustomTransitionAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let viewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) where viewController.isBeingPresented() {
            animateAppearance(of: viewController.view, context: transitionContext)
        } else if let viewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) where viewController.isBeingDismissed() {
            animateDismissal(of: viewController.view, context: transitionContext)
        }
        
    }
    
    private func animateAppearance(of view: UIView, context: UIViewControllerContextTransitioning) {
        context.containerView()?.addSubview(view)
        let rect = context.containerView()!.bounds
        view.frame = rect.translate(CGPoint(x: rect.width, y: 0))
        UIView.animateWithDuration(transitionDuration(context),
                                   delay: 0,
                                   usingSpringWithDamping: 50,
                                   initialSpringVelocity: 20,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: { view.frame = rect }) { completed in
                                    context.completeTransition(completed)
                                    self.delegate?.animationDidFinish(self, presenting: true)
                                  }
    }
    
    private func animateDismissal(of view: UIView, context: UIViewControllerContextTransitioning) {
        let finalRect = view.frame.translate(CGPoint(x: view.bounds.size.width, y: 0))
        UIView.animateWithDuration(transitionDuration(context),
                                   delay: 0,
                                   usingSpringWithDamping: 50,
                                   initialSpringVelocity: 2,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    view.frame = finalRect
                                   }) { completed in
                                    view.removeFromSuperview()
                                    context.completeTransition(completed)
                                    self.delegate?.animationDidFinish(self, presenting: false)
        }
    }
    
}

extension CustomTransitionAnimation: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return UIPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
}