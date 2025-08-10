//
//  EnhancedSearchBar.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 07.08.25.
//

import SwiftUI

struct EnhancedSearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onClear: (() -> Void)?
    
    @FocusState private var isFocused: Bool
    @State private var isEditing = false
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(isEditing ? .accentColor : .secondary)
                    .font(.system(size: 16, weight: .medium))
                
                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isEditing = true
                        }
                    }
                
                if !text.isEmpty {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            text = ""
                            onClear?()
                        }
                        isFocused = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.system(size: 16))
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isEditing ? Color.accentColor : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            
            if isEditing {
                Button("Cancel") {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        text = ""
                        isEditing = false
                        isFocused = false
                        // Скрыть клавиатуру
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    }
                }
                .foregroundColor(.accentColor)
                .padding(.leading, 8)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .onChange(of: isFocused) {
            withAnimation(.easeInOut(duration: 0.2)) {
                isEditing = isFocused
            }
        }
        .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    }
}

#Preview("Empty State") {
    EnhancedSearchBar(
        text: .constant(""),
        placeholder: "Search cocktails..."
    )
    .padding()
}

#Preview("With Text") {
    EnhancedSearchBar(
        text: .constant("Margarita"),
        placeholder: "Search cocktails..."
    )
    .padding()
}

#Preview("Interactive") {
    @Previewable @State var searchText = ""
    
    VStack {
        EnhancedSearchBar(
            text: $searchText,
            placeholder: "Search cocktails..."
        )
        .padding()
        
        Text("Current: \(searchText)")
            .padding()
    }
}
