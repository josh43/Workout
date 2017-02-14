//
//  SplitViewController.swift
//  WorkoutApp
//
//  Created by joshua on 2/9/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import UIKit

/// Class used to to support table view and its details
class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Neccessary to override, else SplitViewController will start directly on exercise
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true;
    }



}
