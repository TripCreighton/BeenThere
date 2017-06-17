//
//  SettingsTVC.swift
//  BeenThere
//
//  Created by Trip Creighton on 2/15/17.
//  Copyright © 2017 Trip Creighton. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    private let defaults = UserDefaults(),
                defaultKeys = DefaultKeys()
    
    @IBOutlet var autoLocateSwitch: UISwitch!,
                  autoTraceSwitch: UISwitch!

    var shouldAutoLocate:Bool? = false {
        didSet {
            self.defaults.set(shouldAutoLocate, forKey: defaultKeys.shouldAutoLocate)
        }
    }
    
    var shouldAutoTrace:Bool? = false {
        didSet {
            self.defaults.set(shouldAutoTrace, forKey: defaultKeys.shouldAutoTrace)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove extra cells:
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.backgroundColor = UIColor(r: 230, g: 230, b: 230, a: 255)
        
        // Retrieve keys:
        shouldAutoLocate = defaults.bool(forKey: defaultKeys.shouldAutoLocate)
        shouldAutoTrace = defaults.bool(forKey: defaultKeys.shouldAutoTrace)
        
        // Set switch states to variable values:
        autoLocateSwitch.isOn = shouldAutoLocate!
        autoTraceSwitch.isOn = shouldAutoTrace!
    }

    @IBAction func autoTracePressed(_ sender: UISwitch) {
        shouldAutoTrace = autoTraceSwitch.isOn
    }
    
    @IBAction func autoLocatePressed(_ sender: UISwitch) {
        shouldAutoLocate = autoLocateSwitch.isOn
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerLabel = (view as! UITableViewHeaderFooterView).textLabel {
            headerLabel.textColor = UIColor(r: 37, g: 164, b: 254, a: 255)
        }
    }
}
