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

    var groupedItems: [(movie: MovieCart, cartIds: [Int], totalQuantity: Int)] {
        var grouped: [String: (MovieCart, [Int], Int)] = [:]
        
        for item in cartItems {
            if let name = item.name, let cartId = item.cartId {
                if let existing = grouped[name] {
                    var cartIds = existing.1
                    cartIds.append(cartId)
                    let totalQuantity = existing.2 + (item.orderAmount ?? 1)
                    grouped[name] = (existing.0, cartIds, totalQuantity)
                } else {
                    grouped[name] = (item, [cartId], item.orderAmount ?? 1)
                }
            }
        }
        
        return grouped.map { $0.value }
    }
    
    func loadCart() async {
        isLoading = true
        
        do {
            cartItems = try await repository.getCart()
        } catch {
            cartItems = []
            print("Sepet yüklenirken hata: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func deleteSingleItem(movieName: String) async {
        if let itemToDelete = cartItems.first(where: { $0.name == movieName }) {
            if let cartId = itemToDelete.cartId {
                do {
                    let response = try await repository.deleteFromCart(cartId: cartId)
                    if response.success == 1 {
                        cartItems.removeAll { $0.cartId == cartId }
                        
                        if !cartItems.contains(where: { $0.name == movieName }) {
                        }
                    }
                } catch {
                    print("Sepetten silinirken hata: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteAllItems(movieName: String) async {
        let itemsToDelete = cartItems.filter { $0.name == movieName }
        
        for item in itemsToDelete {
            if let cartId = item.cartId {
                do {
                    let response = try await repository.deleteFromCart(cartId: cartId)
                    if response.success == 1 {
                        print("CartId \(cartId) başarıyla silindi")
                    }
                } catch {
                    print("CartId \(cartId) silinirken hata: \(error.localizedDescription)")
                }
            }
        }
        
        await loadCart()
    }
    
    func calculateTotalPrice() -> Int {
        var total = 0
        for item in cartItems {
            let price = item.price ?? 0
            let quantity = item.orderAmount ?? 1
            total += price * quantity
        }
        return total
    }
}
