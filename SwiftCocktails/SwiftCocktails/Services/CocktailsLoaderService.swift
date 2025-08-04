//
//  CocktailsLoaderService.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

final class CocktailsLoaderService {
    static let shared = CocktailsLoaderService()

    private let baseURL = "https://api.api-ninjas.com/v1/cocktail"
    private let apiKey: String
    private let session: URLSession

    private init() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let key = config["API_NINJAS_KEY"] as? String {
            self.apiKey = key
        } else {
            self.apiKey = "YOUR_API_KEY_HERE"
            print("⚠️ Warning: Using hardcoded API key. Please add Config.plist with API_NINJAS_KEY")
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Public API

        func fetchCocktails(matching query: String?, completion: @escaping (Result<[Cocktail], Error>) -> Void) {
            guard var components = URLComponents(string: baseURL) else {
                completion(.failure(ServiceError.invalidURL))
                return
            }

            if let query = query, !query.isEmpty {
                components.queryItems = [URLQueryItem(name: "name", value: query)]
            }

            guard let url = components.url else {
                completion(.failure(ServiceError.invalidURL))
                return
            }

            var request = URLRequest(url: url)
            request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
            request.httpMethod = "GET"

            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(ServiceError.emptyData))
                    }
                    return
                }

                do {
                    let cocktails = try JSONDecoder().decode([Cocktail].self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(cocktails))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }

            task.resume()
        }

        // MARK: - Error Handling
        enum ServiceError: Error, LocalizedError {
            case invalidURL
            case emptyData

            var errorDescription: String? {
                switch self {
                case .invalidURL: return "Invalid URL"
                case .emptyData: return "No data received from server"
                }
            }
        }
    }
