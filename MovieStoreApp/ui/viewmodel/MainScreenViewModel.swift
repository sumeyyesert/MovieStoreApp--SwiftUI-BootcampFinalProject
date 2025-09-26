//
//  MainScreenViewModel.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 20.09.2025.
//

import Foundation

@MainActor
class MainScreenViewModel : ObservableObject {
    private let repository = MovieStoreRepository()
    @Published var moviesList = [Movies]()
    @Published var filteredMovies = [Movies]()
    
    func loadMovies() async {
        do {
            moviesList = try await repository.loadMovies()
        } catch {
            moviesList = [Movies]()
        }
    }
    
    func searchMovies(searchText:String) async {
        do{
            moviesList = try await repository.searchMovies(searchText: searchText)
        }catch{
            moviesList = [Movies]()
        }
    }
    
    
    
    
}
