/*
 The MIT License (MIT)
 
 Copyright (c) 2015 Cereopsis
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

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
}

extension CustomTransitionAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if let viewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) where viewController.isBeingPresented() {
            animatePresentation(of: viewController.view, context: transitionContext)
        } else if let viewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) where viewController.isBeingDismissed() {
            animateDismissal(of: viewController.view, context: transitionContext)
        }
    }
    
    private func animatePresentation(of view: UIView, context: UIViewControllerContextTransitioning) {
        guard let container = context.containerView() else {
            return
        }
        container.addSubview(view)
        let rect = container.bounds
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
