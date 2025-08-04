//
//  CocktailListView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 05.08.25.
//

import SwiftUI

struct CocktailListView: View {
    let cocktails: [Cocktail]
    var onRefresh: (() -> Void)? = nil
    
    var body: some View {
        List(cocktails) { cocktail in
            NavigationLink(destination: CocktailDetailView(cocktail: cocktail)) {
                CocktailRowView(cocktail: cocktail)
            }
        }
        .listStyle(.plain)
        .refreshable {
            onRefresh?()
        }
    }
}
