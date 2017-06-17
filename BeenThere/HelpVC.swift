//
//  HelpVC.swift
//  BeenThere
//
//  Created by Trip Creighton on 2/15/17.
//  Copyright © 2017 Trip Creighton. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {
    
    @IBOutlet var confirmButtonView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButtonView.layer.borderColor = UIColor.clear.cgColor
        confirmButtonView.layer.borderWidth = 1
        confirmButtonView.layer.cornerRadius = 5
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
