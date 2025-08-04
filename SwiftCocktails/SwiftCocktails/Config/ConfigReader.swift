//
//  ConfigReader.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

struct ConfigReader {
    static func value(for key: String) throws -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plistConfig = NSDictionary(contentsOfFile: path) else {
            throw ConfigError.missingPlist
        }
        
        guard let value = plistConfig[key] as? String, !value.isEmpty else {
            throw ConfigError.missingKey(key)
        }
        
        return value
    }
}
