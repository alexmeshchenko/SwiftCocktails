//
//  ConfigValue.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

@propertyWrapper
struct ConfigValue {
    let key: String
    let defaultValue: String?
    
    init(key: String, defaultValue: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plistConfig = NSDictionary(contentsOfFile: path),
              let value = plistConfig[key] as? String else {
            guard let defaultValue = defaultValue else {
                fatalError("Missing config value for key: \(key)")
            }
            return defaultValue
        }
        return value
    }
}
