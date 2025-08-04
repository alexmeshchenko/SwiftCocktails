//
//  CocktailImageService.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

final class CocktailImageService {
    func fetchThumbnail(for cocktailName: String) async -> URL? {
        guard !cocktailName.isEmpty,
              var comp = URLComponents(string: Constants.API.imageBaseURL) else { return nil }
        
        comp.queryItems = [.init(name: "s", value: cocktailName)]
        guard let url = comp.url else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parsed = try JSONDecoder().decode(CocktailDBResponse.self, from: data)
            return parsed.drinks?.first?.imageURL
        } catch {
            print("Error fetching thumbnail: \(error)")
            return nil
        }
    }
}
