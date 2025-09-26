//
//  MovieStoreRepository.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 18.09.2025.
//

import Foundation

class MovieStoreRepository {
    private let baseUrl = "http://kasimadalan.pe.hu/movies/"
    private let userName = "sumeyye_sert"
    private let favoritesKey: String
    
    init() {
        self.favoritesKey = "favoriteMovies_\(userName)"
    }
    
    func loadMovies() async throws -> [Movies] {
        let apiUrl = "\(baseUrl)getAllMovies.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
        
        return moviesResponse.movies!
    }
    
    func addToCart(movie: Movies, quantity: Int) async throws -> CRUDResponse {
        let apiUrl = "\(baseUrl)insertMovie.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = "name=\(movie.name ?? "")&image=\(movie.image ?? "")&price=\(movie.price ?? 0)&category=\(movie.category ?? "")&rating=\(movie.rating ?? 0)&year=\(movie.year ?? 0)&director=\(movie.director ?? "")&description=\(movie.description ?? "")&orderAmount=\(quantity)&userName=\(userName)"
        
        request.httpBody = postString.data(using: .utf8)
        
        let (data,_) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(CRUDResponse.self, from: data)
    }
    
    func searchMovies(searchText:String) async throws -> [Movies] {
        let apiUrl = "\(baseUrl)search.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "name=\(searchText)"
        request.httpBody = postString.data(using: .utf8)
                
        let (data,_) = try await URLSession.shared.data(for: request)
        let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
        
        return moviesResponse.movies ?? []
    }
    
    func getCart() async throws -> [MovieCart] {
        let apiUrl = "\(baseUrl)getMovieCart.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "userName=\(userName)"
        request.httpBody = postString.data(using: .utf8)
                
        let (data,_) = try await URLSession.shared.data(for: request)
        let cartResponse = try JSONDecoder().decode(MovieCartResponse.self, from: data)
        
        return cartResponse.movie_cart ?? []
    }

    func deleteFromCart(cartId: Int) async throws -> CRUDResponse {
        let apiUrl = "\(baseUrl)deleteMovie.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "cartId=\(cartId)&userName=\(userName)"
        request.httpBody = postString.data(using: .utf8)
        
        let (data,_) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(CRUDResponse.self, from: data)
    }
    
    func getFavorites() -> [Movies] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            if let decoded = try? JSONDecoder().decode([Movies].self, from: data) {
                return decoded
            }
        }
        return []
    }
    
    func addToFavorites(movie: Movies) -> Bool {
        var favorites = getFavorites()

        if !favorites.contains(where: { $0.id == movie.id }) {
            favorites.append(movie)
            
            if let encoded = try? JSONEncoder().encode(favorites) {
                UserDefaults.standard.set(encoded, forKey: favoritesKey)
                return true
            }
        }
        return false
    }
    
    func removeFromFavorites(movieId: Int) -> Bool {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == movieId }
        
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
            return true
        }
        return false
    }
    
    func isFavorite(movie: Movies) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(where: { $0.id == movie.id })
    }
    
    
}
