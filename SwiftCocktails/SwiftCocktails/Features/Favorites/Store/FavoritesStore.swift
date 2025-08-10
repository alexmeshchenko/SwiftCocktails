//
//  FavoritesStore.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 10.08.25.
//

import SwiftUI

@MainActor
final class FavoritesStore: ObservableObject {
    @Published private(set) var favoriteIDs: Set<String> = []
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "savedCocktailFavorites"
    
    init() {
        load()
    }
    
    // MARK: - Public Methods
    
    func toggle(_ cocktail: Cocktail) {
        if isFavorite(cocktail) {
            favoriteIDs.remove(cocktail.id)
        } else {
            favoriteIDs.insert(cocktail.id)
        }
        save()
    }
    
    func isFavorite(_ cocktail: Cocktail) -> Bool {
        favoriteIDs.contains(cocktail.id)
    }
    
    func getFavorites(from cocktails: [Cocktail]) -> [Cocktail] {
        cocktails.filter { favoriteIDs.contains($0.id) }
    }
    
    var count: Int {
        favoriteIDs.count
    }
    
    // MARK: - Private Methods
    
    private func save() {
        let idsArray = Array(favoriteIDs)
        userDefaults.set(idsArray, forKey: favoritesKey)
    }
    
    private func load() {
        guard let savedIDs = userDefaults.object(forKey: favoritesKey) as? [String] else {
            return
        }
        favoriteIDs = Set(savedIDs)
    }
}
