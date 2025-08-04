//
//  CocktailViewModel.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation
@MainActor
class CocktailViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    func search(for query: String) {
        isLoading = true
        errorMessage = nil
        cocktails = []

        CocktailsLoaderService.shared.fetchCocktails(matching: query) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let list):
                Task { await self.augment(list: list) }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func augment(list: [Cocktail]) async {
        var new = [Cocktail]()
        for var c in list {
            await withCheckedContinuation { cont in
                CocktailImageService().fetchThumbnail(for: c.name) { url in
                    c = Cocktail(name: c.name, ingredients: c.ingredients, instructions: c.instructions, imageURL: url)
                    new.append(c)
                    cont.resume()
                }
            }
        }
        cocktails = new
    }
}
