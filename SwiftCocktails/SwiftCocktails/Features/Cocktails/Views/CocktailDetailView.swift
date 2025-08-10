//
//  CocktailDetailView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import SwiftUI
struct CocktailDetailView: View {
    let cocktail: Cocktail
    @EnvironmentObject var favoritesStore: FavoritesStore
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Изображение с кнопкой избранного
                ZStack(alignment: .topTrailing) {
                    if let url = cocktail.imageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(8)
                            case .failure:
                                // fallback если загрузка не удалась
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.gray)
                                    .opacity(0.6)
                            case .empty:
                                // индикатор загрузки
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                                
                            @unknown default:
                                // Проскакивает для новых (неожиданных) кейсов
                                EmptyView()
                            }
                        }
                        .animation(.default, value: cocktail.imageURL)
                    }
                    
                    // Кнопка избранного
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            favoritesStore.toggle(cocktail)
                            isFavorite.toggle()
                        }
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavorite ? .red : .white)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.3))
                                    .background(
                                        Circle()
                                            .fill(Material.ultraThin)
                                    )
                            )
                            .scaleEffect(isFavorite ? 1.1 : 1.0)
                    }
                    .padding()
                }
                Text(cocktail.name.capitalized)
                    .font(.largeTitle).bold()
                
                Text("Ingredients")
                    .font(.title2).padding(.bottom, 4)
                ForEach(cocktail.ingredients, id: \.self) { ingredient in
                    Text("• \(ingredient)").font(.body)
                }
                
                Text("Instructions")
                    .font(.title2).padding(.top, 16)
                Text(cocktail.instructions)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
        .navigationTitle(cocktail.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isFavorite = favoritesStore.isFavorite(cocktail)
        }
    }
}
