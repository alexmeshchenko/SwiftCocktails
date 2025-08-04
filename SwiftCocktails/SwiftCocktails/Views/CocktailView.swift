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
                HStack {
                    TextField("Search for a cocktail...", text: $searchQuery)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        viewModel.search(for: searchQuery)
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.leading, 4)
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
