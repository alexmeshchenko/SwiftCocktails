//
//  CocktailImageService.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

final class CocktailImageService {
    private let base = "https://www.thecocktaildb.com/api/json/v1/1/search.php"

    func fetchThumbnail(
        for cocktailName: String,
        completion: @escaping (URL?) -> Void
    ) {
        guard !cocktailName.isEmpty else { return completion(nil) }
        guard var comp = URLComponents(string: base) else {
            return completion(nil)
        }
        comp.queryItems = [ .init(name: "s", value: cocktailName) ]
        guard let url = comp.url else {
            return completion(nil)
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard
              let d = data,
              let parsed = try? JSONDecoder().decode(CocktailDBResponse.self, from: d),
              let thumb = parsed.drinks.first?.imageURL
            else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async { completion(thumb) }
        }
        task.resume()
    }
}

// вспомогательные структуры:
struct CocktailDBResponse: Codable {
    let drinks: [Drink]
    struct Drink: Codable {
        let strDrink: String
        let strDrinkThumb: URL
        var imageURL: URL? { strDrinkThumb }
    }
}
