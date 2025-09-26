//
//  MovieDetailsViewModel.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import Foundation

@MainActor
class MovieDetailsViewModel: ObservableObject {
    private let repository = MovieStoreRepository()
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func addToCart(movie: Movies, quantity: Int) async {
        isLoading = true
        
        do {
            let response = try await repository.addToCart(movie: movie, quantity: quantity)
            
            if response.success == 1 {
                alertMessage = "\(quantity) adet \(movie.name ?? "film") sepete eklendi!"
            } else {
                alertMessage = "Sepete eklenirken hata oluştu: \(response.message ?? "Bilinmeyen hata")"
            }
            
            showAlert = true
        } catch {
            alertMessage = "Sepete eklenirken hata oluştu: \(error.localizedDescription)"
            showAlert = true
        }
        
        isLoading = false
    }
}
