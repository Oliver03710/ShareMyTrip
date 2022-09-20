//
//  UserDefaultsHelper.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import Foundation

class UserdefaultsHelper {
    
    private init() { }
    
    static let standard = UserdefaultsHelper()
    
    let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case tripName, isTraveling, companions
    }
    
    var tripName: String {
        get {
            return userDefaults.string(forKey: Key.tripName.rawValue) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: Key.tripName.rawValue)
        }
    }
    
    var isTraveling: Bool {
        get {
            return userDefaults.bool(forKey: Key.isTraveling.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.isTraveling.rawValue)
        }
    }
    
    var companions: [String] {
        get {
            return userDefaults.object(forKey: Key.companions.rawValue) as! [String]
        }
        set {
            userDefaults.set(newValue, forKey: Key.companions.rawValue)
        }
    }
    func removeAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: appDomain)
        }
    }
    
}
