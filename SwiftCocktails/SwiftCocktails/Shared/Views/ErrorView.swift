//
//  ErrorView.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 05.08.25.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
