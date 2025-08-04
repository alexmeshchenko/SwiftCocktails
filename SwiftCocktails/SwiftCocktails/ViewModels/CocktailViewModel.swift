//
//  CocktailViewModel.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

final class CocktailViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func search(for query: String) {
        isLoading = true
        errorMessage = nil
        cocktails = []

        CocktailsLoaderService.shared.fetchCocktails(matching: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let list):
                print("✅ Loaded cocktails: \(list.map(\.name))")
                self.cocktails = list
                if list.isEmpty {
                    self.errorMessage = "No cocktails found."
                }
            case .failure(let error):
                print("❌ Error: \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
