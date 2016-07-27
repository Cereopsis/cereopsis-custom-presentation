//
//  NibbedViewController.swift
//  Boardwalk
//
//  Created by John Walker on 27/07/2016.
//  Copyright © 2016 John Walker. All rights reserved.
//

import UIKit

class NibbedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nibbed"
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(second(_:)))
        navigationItem.rightBarButtonItem = button
    }

    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func second(sender: UIBarButtonItem) {
        let secondVc = SecondViewController(nibName: nil, bundle: nil)
        showViewController(secondVc, sender: sender)
    }
}
