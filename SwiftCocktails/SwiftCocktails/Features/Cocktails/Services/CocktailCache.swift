//
//  CocktailCache.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 10.08.25.
//

import SwiftUI

@MainActor
final class CocktailCache: ObservableObject {
    static let shared = CocktailCache()
    
    @Published private(set) var cachedCocktails: [String: Cocktail] = [:]
    
    private init() {}
    
    func add(_ cocktails: [Cocktail]) {
        for cocktail in cocktails {
            cachedCocktails[cocktail.id] = cocktail
        }
    }
    
    func get(_ id: String) -> Cocktail? {
        cachedCocktails[id]
    }
    
    func getMultiple(_ ids: Set<String>) -> [Cocktail] {
        ids.compactMap { cachedCocktails[$0] }
    }
}
