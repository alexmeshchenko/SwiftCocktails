//
//  Constants.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 05.08.25.
//

import Foundation

enum Constants {
    enum Network {
        static let cocktailsBaseURL = "https://api.api-ninjas.com/v1/cocktail"
        static let imagesBaseURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php"
        static let timeoutInterval: TimeInterval = 20
    }
    
    enum Search {
        static let debounceInterval = 500  // milliseconds
        static let minimumCharacters = 1
    }
    
    enum Animation {
        static let defaultDuration = 0.3
        static let springDamping = 0.8
    }
    
    enum Layout {
        static let defaultPadding: CGFloat = 16
        static let itemSpacing: CGFloat = 8
        static let thumbnailSize: CGFloat = 60
    }
}
