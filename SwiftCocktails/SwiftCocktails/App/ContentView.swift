//
//  ContentView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import SwiftUI
 
struct ContentView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    
    var body: some View {
        TabView {
            CocktailView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .badge(favoritesStore.favoriteIDs.isEmpty ? 0 : favoritesStore.count)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FavoritesStore())
}
