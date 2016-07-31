//
//  CustomPresentation.swift
//  Boardwalk
//
//  Created by John Walker on 27/07/2016.
//  Copyright © 2016 John Walker. All rights reserved.
//

import UIKit

extension CGRect {
    var centre: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

class CustomPresentation: UIPresentationController {

    override func presentationTransitionWillBegin() {
        if let view = presentedView() {
            view.center = containerView!.center
        }
        print("\(#function)")
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        print("\(#function)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("\(#function)")
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        let rect = super.frameOfPresentedViewInContainerView()
        print(rect)
        return rect
    }
    
}
