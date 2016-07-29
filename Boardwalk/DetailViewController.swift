//
//  DetailViewController.swift
//  Boardwalk
//
//  Created by John Walker on 29/07/2016.
//  Copyright © 2016 John Walker. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var model: DetailViewModel!


    /// Tell our model object about trait changes without needing to know what that means.
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        model.didUpdateTraitCollection(traitCollection)
    }
    
    
    @IBAction func showNibbedView(sender: AnyObject) {
        let nibbed = NibbedViewController(nibName: nil, bundle: nil)
        showViewController(nibbed, sender: sender)
    }

}
