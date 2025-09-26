//
//  FavoritesViewModel.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import Foundation

@MainActor
class FavoritesViewModel: ObservableObject {
    private let repository = MovieStoreRepository()
    @Published var favoriteMovies: [Movies] = []
    
    func loadFavorites() {
        favoriteMovies = repository.getFavorites()
    }
    
    func addToFavorites(movie: Movies) -> Bool {
        let success = repository.addToFavorites(movie: movie)
        if success {
            loadFavorites()
        }
        return success
    }
    
    func removeFromFavorites(movieId: Int) -> Bool {
        let success = repository.removeFromFavorites(movieId: movieId)
        if success {
            loadFavorites() 
        }
        return success
    }
    
    func isFavorite(movie: Movies) -> Bool {
        return repository.isFavorite(movie: movie)
    }
}
