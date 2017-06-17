//
//  ViewController.swift
//  BeenThere
//
//  Created by Trip Creighton on 2/10/17.
//  Copyright © 2017 Trip Creighton. All rights reserved.
//

import UIKit
import MapKit

class MainVC: UIViewController {
    
    private let defaults = UserDefaults(),
                defaultKeys = DefaultKeys()
    
    private var mapManager: MapManager!,
                utils = Utilities(),
                blueColor = UIColor(r: 37, g: 164, b: 254, a: 255) ,
                whiteColor = UIColor(r: 230, g: 230, b: 230, a: 255),
                selectedBlueColor = UIColor(r: 12, g: 98, b: 150, a: 255)
    
    @IBOutlet var navBar: UINavigationBar!,
                  showPositionView: UIView!,
                  showPositionButton: UIButton!,
                  dropPinView: UIView!,
                  dropPinButton: UIButton!,
                  mapTracerView: UIView!,
                  mapTracerButton: UIButton!,
                  removePinView: UIView!,
                  removePinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        //Setup map manager:
        mapManager = MapManager(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), mapType: .hybridFlyover)
        mapManager.showCompass = false
        
        //Setup show position view & button:
        showPositionView.layer.borderColor = whiteColor?.cgColor
        showPositionView.layer.borderWidth = 1
        showPositionView.layer.cornerRadius = 2
        view.bringSubview(toFront: showPositionView)
        showPositionButton.setImage(UIImage(named: "locate")?.withRenderingMode(.alwaysTemplate), for: .normal)
        showPositionButton.tintColor = whiteColor
        if mapManager.shouldTrackUser! {
            showPositionView.backgroundColor = selectedBlueColor
            mapManager.shouldTrackUser = true // I still need to notify the mapview to start tracking the user! :)
        }
        
        //Setup map tracer view & button:
        mapTracerView.layer.borderColor = whiteColor?.cgColor
        mapTracerView.layer.borderWidth = 1
        mapTracerView.layer.cornerRadius = 2
        view.bringSubview(toFront: mapTracerView)
        mapTracerButton.setImage(UIImage(named: "dotted-map")?.withRenderingMode(.alwaysTemplate), for: .normal)
        mapTracerButton.tintColor = whiteColor
        if mapManager.shouldTraceRoute! {
            mapTracerView.backgroundColor = selectedBlueColor
        }
        
        //Setup drop pin view & button:
        dropPinView.layer.borderColor = whiteColor?.cgColor
        dropPinView.layer.borderWidth = 1
        dropPinView.layer.cornerRadius = 2
        view.bringSubview(toFront: dropPinView)
        dropPinButton.setImage(UIImage(named: "pin")?.withRenderingMode(.alwaysTemplate), for: .normal)
        dropPinButton.tintColor = whiteColor
        
        //Setup remove pin view & button:
        removePinView.layer.borderColor = whiteColor?.cgColor
        removePinView.layer.borderWidth = 1
        removePinView.layer.cornerRadius = 2
        view.bringSubview(toFront: removePinView)
        removePinButton.setImage(UIImage(named: "remove-pin")?.withRenderingMode(.alwaysTemplate), for: .normal)
        removePinButton.tintColor = whiteColor
        if mapManager.deletePinTapped! {
            removePinView.backgroundColor = selectedBlueColor
        }
        
        //Setup nav bar:
        navBar.layer.borderColor = whiteColor?.cgColor
        navBar.layer.borderWidth = 1
        navBar.layer.cornerRadius = 1
        navBar.clipsToBounds = true
        navBar.bringSubview(toFront: navBar)
        
        view.addSubview(mapManager.mapView)
        view.sendSubview(toBack: mapManager.mapView)
        
        // Retrieve these keys based  on SETTINGS not on MAP MANAGER keys:
        mapManager.shouldTraceRoute = defaults.bool(forKey: defaultKeys.shouldAutoTrace)
        mapManager.shouldTraceRoute = defaults.bool(forKey: defaultKeys.shouldAutoLocate)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func unwindSettings(from: UIStoryboardSegue) {
        guard let src:SettingsTVC = from.source as? SettingsTVC else {
            print("[\(utils.getTime())] Error! Cannot cast unwindSettings source to SettingsTVC!")
            return
        }
        // Fetch settings here - NONe CURRENTLY SINCE ALL SETTINGS START ON STARTUP:
    }
    
    @IBAction func showLocationButtonPressed(_ sender: UIButton) {
        mapManager.shouldTrackUser = !mapManager.shouldTrackUser!
        if mapManager.shouldTrackUser! {
            showPositionView.backgroundColor = selectedBlueColor
        } else {
            showPositionView.backgroundColor = blueColor
        }
    }
    
    @IBAction func dropPinButtonPressed(_ sender: UIButton) {
        mapManager.dropPin(coord: mapManager.currentUserLocation, withTitle: "test", andDescription: "test")
    }
    
    @IBAction func mapTracerButtonPressed(_ sender: UIButton) {
        mapManager.shouldTraceRoute = !mapManager.shouldTraceRoute!
        if mapManager.shouldTraceRoute! {
            mapTracerView.backgroundColor = selectedBlueColor
        } else {
            mapTracerView.backgroundColor = blueColor
        }
    }
    
    @IBAction func removePinButtonPressed(_ sender: UIButton) {
        mapManager.deletePinTapped = !mapManager.deletePinTapped!
        if mapManager.deletePinTapped! {
            removePinView.backgroundColor = selectedBlueColor
        } else {
            removePinView.backgroundColor = blueColor
        }
    }
}

