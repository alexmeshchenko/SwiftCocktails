//
//  CocktailView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import SwiftUI

struct CocktailView: View {
    @StateObject private var viewModel = CocktailViewModel()
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for a cocktail...", text: $searchQuery, onCommit: {
                    viewModel.search(for: searchQuery)
                })
                .textFieldStyle(.roundedBorder)
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

                List(viewModel.cocktails) { cocktail in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(cocktail.name)
                            .font(.headline)
                        Text("Ingredients: \(cocktail.ingredients.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
            .navigationTitle("🍹 Cocktails")
        }
    }
}
