//
//  Utilities.swift
//  Encrypter
//
//  Created by Trip Creighton on 1/28/17.
//  Copyright © 2017 Trip Creighton. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    private let timeComponents = Date(),
    timeFormatter = DateFormatter()
    
    func getDate() -> String {
        timeFormatter.dateFormat = "dd.MM.yyyy"
        return timeFormatter.string(from: timeComponents)
    }
    
    func getTime() -> String {
        timeFormatter.dateFormat = "HH:mm:ss"
        return timeFormatter.string(from: timeComponents)
    }
    
    func get2DDistance(xy: CGPoint, xy1: CGPoint) -> Double {
        return Double(sqrt(((xy1.x - xy.x) * 2) + ((xy1.y - xy.y) * 2)))
    }
}

// Keys for anything you might need keys for:
struct DefaultKeys {
    let lastLocation = "lastLocation"
    let lastRegion = "lastRegion"
    let showCompass = "showCompass"
    let showUserLocation = "showUserLocation"
    let annotationLatitudeList = "annotationLatitudeList"
    let annotationLongitudeList = "lastLongitude"
    let shouldAutoLocate = "shouldAutoLocate"
    let shouldAutoTrace = "shouldAutoTrace"
    let shouldTrackUser = "shouldTrackUser" // Different from should auto locate
    let shouldTracePath = "shouldTracePath" // Different from should auto trace
}


extension String {
    
    var count:Int {
        return self.characters.count
    }
    
    func array() -> [Character] {
        var arr:[Character]! = []
        for char in self.characters {
            arr.append(char)
        }
        return arr
    }
    
    func at(_ pos: Int) -> Character? {
        if self.characters.count < pos {
            return nil
        }
        return self.array()[pos]
    }
    
    func base64Encode() -> String {
        return (self.data(using: String.Encoding.utf8)?.base64EncodedString())!
    }
    
    func base64Decode() -> String {
        return String(data: Data(base64Encoded: self)!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
    }
}



extension UIWebView {
    func parseAndLoad(_ query: String) {
        if query.contains(" ") {
            self.loadRequest(URLRequest(url: URL(string: "https://www.google.com/?q=\(query.replacingOccurrences(of: " ", with: "+"))")!))
        } else {
            self.loadRequest(URLRequest(url: URL(string: query)!))
        }
    }
}

extension UIColor {
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a/255)
    }
}

extension Character {
    func toAscii() -> UInt32 {
        return String(self).unicodeScalars[String(self).unicodeScalars.startIndex].value
    }
    
    func isAlpha() -> Bool{
        return "abcdefghijklmnopqrstuvwxyz".contains(String(self)) || "ABDEFGHIJKLMNOPQRSTUVWXYZ".contains(String(self))
    }
}
