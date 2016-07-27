//
//  ViewController.swift
//  Boardwalk
//
//  Created by John Walker on 27/07/2016.
//  Copyright © 2016 John Walker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var transition: UIViewControllerTransitioningDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func launchNibbedController(sender: AnyObject) {
        let nibbed = NibbedViewController(nibName: nil, bundle: nil)
        let navigator = UINavigationController(rootViewController: nibbed)
        navigator.modalPresentationStyle = .Custom
        transition = CustomTransitionAnimation(delegate: self)
        navigator.transitioningDelegate = transition
        presentViewController(navigator, animated: true, completion: nil)
    }

}

extension ViewController: CustomTransitionAnimationDelegate {
    func animationDidFinish(context: CustomTransitionAnimation, presenting: Bool) {
        if !presenting && context.isEqual(transition) {
            transition = nil
        }
    }
}

