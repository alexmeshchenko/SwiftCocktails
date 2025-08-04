//
//  CocktailDBResponse.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

// вспомогательные структуры:
struct CocktailDBResponse: Codable {
    let drinks: [Drink]?
    
    struct Drink: Codable {
        let strDrink: String
        let strDrinkThumb: URL?
        var imageURL: URL? { strDrinkThumb }
    }
}
