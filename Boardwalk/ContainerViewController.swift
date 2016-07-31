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

/// A ViewController whose sole reason for existence is to manage the trait-forcing on its childViewControllers.
class ContainerViewController: UIViewController {

    var design: Design?
    
    /// Here we perform the trait-forcing and escape the perils of a layout loop
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        design = Design(compactWidth: size.isNarrowWidth)
        for child in childViewControllers {
            setOverrideTraitCollection(design?.traitCollection, forChildViewController: child)
        }
    }
    
    /// Returns a traitCollection as decided by the current `Design`
    override func overrideTraitCollection(forChildViewController childViewController: UIViewController) -> UITraitCollection? {
        return design?.traitCollection
    }
    
    /// Layout Loop Alert! Do NOT be tempted to call setOverrideTraitCollection here
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        design = Design(compactWidth: view.bounds.size.isNarrowWidth)
    }

}
