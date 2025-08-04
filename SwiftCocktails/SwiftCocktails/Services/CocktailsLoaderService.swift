//
//  CocktailsLoaderService.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation

final class CocktailsLoaderService {
    enum ConfigError: Error {
        case missingAPIKey
    }
    
    static let shared: CocktailsLoaderService? = try? CocktailsLoaderService()
    
    private let baseURL = "https://api.api-ninjas.com/v1/cocktail"
    private let apiKey: String
    private let session: URLSession
    
    private init() throws {
        // Читаем конфигурацию из plist
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plistConfig = NSDictionary(contentsOfFile: path),  // Переименовали в plistConfig
              let key = plistConfig["API_NINJAS_KEY"] as? String,
              !key.isEmpty else {
            throw ConfigError.missingAPIKey
        }
        self.apiKey = key
        
        // Настраиваем URLSession
        let sessionConfig = URLSessionConfiguration.default  // Переименовали в sessionConfig
        sessionConfig.timeoutIntervalForRequest = 20
        sessionConfig.timeoutIntervalForResource = 20
        self.session = URLSession(configuration: sessionConfig)
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

extension CocktailsLoaderService {
    func fetchCocktailsAsync(matching query: String?) async throws -> [Cocktail] {
        guard var components = URLComponents(string: baseURL) else {
            throw ServiceError.invalidURL
        }
        
        if let query = query, !query.isEmpty {
            components.queryItems = [URLQueryItem(name: "name", value: query)]
        }
        
        guard let url = components.url else {
            throw ServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.httpMethod = "GET"
        
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode([Cocktail].self, from: data)
    }
}
