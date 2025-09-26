//
//  MovieCart.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 20.09.2025.
//

import Foundation

class MovieCart : Codable, Identifiable {
    var cartId: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var rating: Double?
    var year: Int?
    var director: String?
    var description: String?
    var orderAmount: Int?
    var userName: String?
    
    init() {}
}
