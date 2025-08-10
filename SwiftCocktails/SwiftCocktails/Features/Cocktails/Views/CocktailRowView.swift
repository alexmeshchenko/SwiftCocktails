//
//  CocktailRowView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 05.08.25.
//

import SwiftUI

struct CocktailRowView: View {
    let cocktail: Cocktail
    @EnvironmentObject var favoritesStore: FavoritesStore
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail если есть
            if let imageURL = cocktail.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(cocktail.name.capitalized)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(cocktail.ingredients.joined(separator: " • "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Кнопка избранного
            Button {
                favoritesStore.toggle(cocktail)
            } label: {
                Image(systemName: favoritesStore.isFavorite(cocktail) ? "heart.fill" : "heart")
                    .foregroundColor(favoritesStore.isFavorite(cocktail) ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
