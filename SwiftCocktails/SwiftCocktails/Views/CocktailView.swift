//
//  CocktailView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//
import SwiftUI

struct CocktailView: View {
    @StateObject private var viewModel = CocktailViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    // Привязываем напрямую к published свойству
                    TextField("Search for a cocktail...", text: $viewModel.searchQuery)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    // Без отдельной кнопку поиска

                }
                .padding()

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                if !viewModel.cocktails.isEmpty {
                    List(viewModel.cocktails) { cocktail in
                        NavigationLink(destination: CocktailDetailView(cocktail: cocktail)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(cocktail.name.capitalized)
                                    .font(.headline)
                                Text("Ingredients: \(cocktail.ingredients.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                } else if !viewModel.isLoading && viewModel.errorMessage == nil {
                    Text("No cocktails found.")
                        .foregroundColor(.secondary)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("🍹 Cocktails")
        }
    }
}
