//
//  Cocktail.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

// MARK: - Cocktail Model
struct Cocktail: Identifiable, Codable, Equatable {
    var id: String { name } // имя уникально в API
    let name: String
    let ingredients: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case ingredients
    }
}
