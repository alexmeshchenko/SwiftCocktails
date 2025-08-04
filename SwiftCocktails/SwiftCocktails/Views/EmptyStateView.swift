//
//  EmptyStateView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 05.08.25.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let subtitle: String?
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
            }
        }
        .padding()
    }
}
