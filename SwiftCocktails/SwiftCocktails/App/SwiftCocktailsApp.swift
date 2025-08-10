//
//  SwiftCocktailsApp.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import SwiftUI

@main
struct SwiftCocktailsApp: App {
    @StateObject private var favoritesStore = FavoritesStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesStore)
        }
    }
}
