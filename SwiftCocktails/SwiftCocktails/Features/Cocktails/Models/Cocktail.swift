//
//  Cocktail.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

// MARK: - Cocktail Model
struct Cocktail: Identifiable, Codable, Equatable {
    var id: String { name.lowercased() }

    let name: String
    let ingredients: [String]
    let instructions: String
    let imageURL: URL?
}
