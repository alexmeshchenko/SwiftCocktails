//
//  Constants.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 05.08.25.
//


enum Constants {
    enum API {
        static let baseURL = "https://api.api-ninjas.com/v1/cocktail"
        static let imageBaseURL = "https://www.thecocktaildb.com/api/json/v1/1/search.php"
    }
    
    enum UI {
        static let searchDebounce = 500 // milliseconds
        static let animationDuration = 0.3
    }
}