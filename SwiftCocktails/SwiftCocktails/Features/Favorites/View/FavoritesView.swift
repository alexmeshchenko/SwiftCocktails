//
//  FavoritesView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 10.08.25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    @StateObject private var viewModel = CocktailViewModel()
    @State private var favoriteCocktails: [Cocktail] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if favoriteCocktails.isEmpty {
                    // Пустое состояние
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
            .onAppear {
                loadFavorites()
            }
            .onChange(of: favoritesStore.favoriteIDs) {
                loadFavorites()
            }
        }
    }
    
    private func loadFavorites() {
        // Пока просто фильтруем из загруженных коктейлей
        // В будущем можно загружать только избранные
        favoriteCocktails = viewModel.cocktails.filter { cocktail in
            favoritesStore.isFavorite(cocktail)
        }
    }
}
