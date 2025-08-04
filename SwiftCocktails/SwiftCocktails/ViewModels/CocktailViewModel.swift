//
//  CocktailViewModel.swift
//  SwiftCocktails
//
//  Created by Aleksandr Meshchenko on 04.08.25.
//

import Foundation
import Combine

@MainActor
class CocktailViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var cocktails: [Cocktail] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let imageService = CocktailImageService()
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var lastSearchQuery: String = ""  // Сохраняем последний запрос
    
    init() {
        // Debounce поиска
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(for: query)
            }
            .store(in: &cancellables)
    }
    
    // Добавляем метод retry
    func retry() {
        // Повторяем последний поиск
        search(for: lastSearchQuery)
    }
    
    func search(for query: String) {
        // Сохраняем запрос для retry
        lastSearchQuery = query
        
        // Отменяем предыдущий поиск
        searchTask?.cancel()
        
        isLoading = true
        errorMessage = nil
        cocktails = []
        
        searchTask = Task { @MainActor in
            do {
                // Проверяем, что сервис инициализирован
                guard let service = CocktailsLoaderService.shared else {
                    self.errorMessage = "Configuration error: API key not found"
                    self.isLoading = false
                    return
                }
                
                let result = try await service.fetchCocktailsAsync(matching: query)
                
                // Проверяем, не отменена ли задача
                guard !Task.isCancelled else { return }
                
                let augmented = await augment(list: result)
                guard !Task.isCancelled else { return }
                
                self.cocktails = augmented
            } catch {
                guard !Task.isCancelled else { return }
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    private func augment(list: [Cocktail]) async -> [Cocktail] {
        // Используем TaskGroup для параллельной загрузки изображений
        await withTaskGroup(of: Cocktail.self) { group in
            for cocktail in list {
                group.addTask { // без weak self
//                    TaskGroup автоматически ждет завершения всех задач
//                    Нет долгоживущей ссылки на замыкание (нет замыкания, которое может пережить объект)
//                    Метод augment завершится только после выполнения всех задач
                    let imageURL = await self.imageService.fetchThumbnail(for: cocktail.name)
                    
                    return Cocktail(
                        name: cocktail.name,
                        ingredients: cocktail.ingredients,
                        instructions: cocktail.instructions,
                        imageURL: imageURL
                    )
                }
            }
            
            // Собираем результаты и сохраняем порядок
            var augmentedDict = [String: Cocktail]()
            for await cocktail in group {
                augmentedDict[cocktail.id] = cocktail
            }
            
            // Возвращаем коктели в оригинальном порядке
            return list.compactMap { augmentedDict[$0.id] }
        }
    }
}
