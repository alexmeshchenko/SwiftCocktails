//
//  CocktailDetailView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import SwiftUI
struct CocktailDetailView: View {
    let cocktail: Cocktail
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
    }
}
