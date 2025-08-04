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
        // Debounce поиска // Подписываемся на изменения searchQuery
        $searchQuery
            .debounce(for: .milliseconds(Constants.UI.searchDebounce), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                if query.isEmpty {
                    // Очищаем результаты при пустом запросе
                    self?.clearResults()
                } else {
                    // Ищем только если есть текст
                    self?.search(for: query)
                }
            }
            .store(in: &cancellables)
    }
    
    private func clearResults() {
        searchTask?.cancel()
        cocktails = []
        errorMessage = nil
        isLoading = false
        lastSearchQuery = ""
    }
    
    // Добавляем метод retry
    func retry() {
        // Повторяем только если был предыдущий поиск
        guard !lastSearchQuery.isEmpty else { return }
        search(for: lastSearchQuery)
    }
    
    func search(for query: String) {
        // Дополнительная проверка на всякий случай
        guard !query.isEmpty else {
            clearResults()
            return
        }

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
