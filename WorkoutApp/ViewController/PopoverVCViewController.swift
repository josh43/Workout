//
//  PopoverVCViewController.swift
//  WorkoutApp
//
//  Created by joshua on 2/13/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import UIKit

class PopoverVCViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var text : String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        textView.text = text
    }
    
    
    

    override var preferredContentSize: CGSize{
        get{
            return CGSize(width:200,height:200)
        }
        set{
            super.preferredContentSize = CGSize(width: 200, height: 200)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
