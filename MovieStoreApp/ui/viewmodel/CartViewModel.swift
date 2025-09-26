//
//  CartViewModel.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import Foundation

@MainActor
class CartViewModel: ObservableObject {
    private let repository = MovieStoreRepository()
    @Published var cartItems: [MovieCart] = []
    @Published var isLoading = false
    
    func loadCart() async {
        isLoading = true
        
        do {
            var items = try await repository.getCart()
            items = groupCartItems(items)
            
            cartItems = items
        } catch {
            cartItems = []
            print("Sepet yüklenirken hata: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func groupCartItems(_ items: [MovieCart]) -> [MovieCart] {
        var groupedItems: [String: MovieCart] = [:]
        
        for item in items {
            if let name = item.name {
                if let existingItem = groupedItems[name] {
                    // Aynı film zaten varsa, adet ve toplam fiyatı güncelle
                    existingItem.orderAmount = (existingItem.orderAmount ?? 0) + (item.orderAmount ?? 1)
                } else {
                    // Yeni filmse direkt ekle
                    groupedItems[name] = item
                }
            }
        }
        
        return Array(groupedItems.values)
    }
    
    func deleteFromCart(cartId: Int) async {
        do {
            let response = try await repository.deleteFromCart(cartId: cartId)
            if response.success == 1 {
                await loadCart() // Sepeti yeniden yükle
            }
        } catch {
            print("Sepetten silinirken hata: \(error.localizedDescription)")
        }
    }
    
}
