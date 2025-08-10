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
            VStack(spacing: 0) {                
                // Content
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    ErrorView(message: errorMessage) {
                        viewModel.retry()
                    }
                    Spacer()
                } else if viewModel.cocktails.isEmpty {
                    Spacer()
                    if viewModel.searchQuery.isEmpty {
                        // Начальное состояние
                        EmptyStateView(
                            title: "Search for cocktails",
                            subtitle: "Type a name to find your favorite drink",
                            systemImage: "magnifyingglass"
                        )
                    } else {
                        // Нет результатов
                        EmptyStateView(
                            title: "No cocktails found",
                            subtitle: "Try searching for something else",
                            systemImage: "wineglass"
                        )
                    }
                    Spacer()
                } else {
                    CocktailListView(cocktails: viewModel.cocktails)
                }
            }
            .navigationTitle("🍹 Cocktails")
            .searchable(
                            text: $viewModel.searchQuery,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: "Search for a cocktail..."
                        )
        }
    }
}
