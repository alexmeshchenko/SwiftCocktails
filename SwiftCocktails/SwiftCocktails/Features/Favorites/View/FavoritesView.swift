//
//  FavoritesView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 10.08.25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    private let cache = CocktailCache.shared
    
    var favoriteCocktails: [Cocktail] {
        cache.getMultiple(favoritesStore.favoriteIDs)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if favoriteCocktails.isEmpty && !favoritesStore.favoriteIDs.isEmpty {
                    // Есть избранные, но они не в кеше
                    VStack(spacing: 20) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("Your favorites will appear here")
                            .font(.headline)
                        
                        Text("Search for cocktails first to see them in favorites")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else if favoriteCocktails.isEmpty {
                    // Нет избранных
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No Favorites Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Start adding cocktails to your favorites\nand they'll appear here")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding()
                } else {
                    // Список избранных
                    CocktailListView(cocktails: favoriteCocktails)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
