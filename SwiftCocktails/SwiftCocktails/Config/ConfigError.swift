//
//  ConfigError.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

enum ConfigError: LocalizedError {
    case missingPlist
    case missingKey(String)
    
    var errorDescription: String? {
        switch self {
        case .missingPlist:
            return "Config.plist not found"
        case .missingKey(let key):
            return "Missing required key: \(key)"
        }
    }
}
