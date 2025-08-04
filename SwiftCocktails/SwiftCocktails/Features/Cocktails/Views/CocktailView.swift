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
                // Search bar
                // Привязываем напрямую к published свойству
                TextField("Search for a cocktail...", text: $viewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                // Без отдельной кнопку поиска
                
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
        }
    }
}
