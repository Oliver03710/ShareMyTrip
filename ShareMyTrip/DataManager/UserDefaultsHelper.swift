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
        case isTraveling
    }
    
    var isTraveling: Bool {
        get {
            return userDefaults.bool(forKey: Key.isTraveling.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.isTraveling.rawValue)
        }
    }
    
    func removeAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: appDomain)
        }
    }
    
}
