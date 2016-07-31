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
    func translate(_ point: CGPoint) -> CGRect {
        return CGRect(x: minX + point.x, y: minY + point.y, width: width, height: height)
    }
}

protocol CustomTransitionAnimationDelegate: class {
    func animationDidFinish(_ context: CustomTransitionAnimation, presenting: Bool)
}

class CustomTransitionAnimation: NSObject {
    
    weak var delegate: CustomTransitionAnimationDelegate?
    
    init(delegate: CustomTransitionAnimationDelegate) {
        self.delegate = delegate
        super.init()
    }
}

extension CustomTransitionAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let viewController = transitionContext.viewController(forKey: UITransitionContextToViewControllerKey) , viewController.isBeingPresented() {
            animatePresentation(of: viewController.view, context: transitionContext)
        } else if let viewController = transitionContext.viewController(forKey: UITransitionContextFromViewControllerKey) , viewController.isBeingDismissed() {
            animateDismissal(of: viewController.view, context: transitionContext)
        }
    }
    
    private func animatePresentation(of view: UIView, context: UIViewControllerContextTransitioning) {
        let container = context.containerView()
        container.addSubview(view)
        let rect = container.bounds
        view.frame = rect.translate(CGPoint(x: rect.width, y: 0))
        UIView.animate(withDuration: transitionDuration(using: context),
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.5,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: { view.frame = rect }) { completed in
                                    context.completeTransition(completed)
                                    self.delegate?.animationDidFinish(self, presenting: true)
        }
    }
    
    private func animateDismissal(of view: UIView, context: UIViewControllerContextTransitioning) {
        let finalRect = view.frame.translate(CGPoint(x: view.bounds.size.width, y: 0))
        UIView.animate(withDuration: transitionDuration(using: context),
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.5,
                                   options: UIViewAnimationOptions(),
                                   animations: { view.frame = finalRect}) { completed in
                                    view.removeFromSuperview()
                                    context.completeTransition(completed)
                                    self.delegate?.animationDidFinish(self, presenting: false)
        }
    }
    
}

extension CustomTransitionAnimation: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return UIPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
