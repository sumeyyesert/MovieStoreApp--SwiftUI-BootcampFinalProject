//
//  Movies.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 20.09.2025.
//

import Foundation

class Movies: Identifiable, Codable {
    var id: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var rating: Double?
    var year: Int?
    var director: String?
    var description: String?
    
    init() {}
}
