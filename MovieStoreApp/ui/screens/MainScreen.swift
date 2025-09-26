//
//  ContentView.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 18.09.2025.
//

import SwiftUI

struct MainScreen: View {
    @State private var searchText = ""
    @ObservedObject var viewModel = MainScreenViewModel()
    @State private var selectedCategory = "Tümü"
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                Group {
                    if viewModel.moviesList.isEmpty {
                        Text("Film Bulunamadı")
                            .foregroundColor(AppColors.textColor2)
                    } else {
                        VStack(spacing: 0) {
                            // Kategoriler
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(getAllCategories(), id: \.self) { category in
                                        Button {
                                            selectedCategory = category
                                        } label: {
                                            Text(category)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedCategory == category ? AppColors.mainColor : AppColors.cardBackground)
                                                .foregroundColor(selectedCategory == category ? .white : AppColors.textColor)
                                                .cornerRadius(20)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(AppColors.borderColor, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                            }
                            .background(AppColors.cardBackground)
                            
                            // Film Grid
                            ScrollView {
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 16) {
                                    ForEach(getMoviesByCategory(selectedCategory)) { movie in
                                        NavigationLink(destination: MovieDetailsScreen(movie: movie)) {
                                            MovieGridCard(movie: movie)
                                                .background(AppColors.cardBackground)
                                                .cornerRadius(12)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .stroke(AppColors.borderColor, lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                                .padding()
                            }
                            .background(AppColors.background)
                        }
                    }
                }
            }
            .navigationTitle("Filmler")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                Task {
                    await viewModel.loadMovies()
                }
            }
        }
        .searchable(text: $searchText, prompt: "Film ara...")
        .searchable(text: $searchText, prompt: "Film ara...")
        .foregroundColor(AppColors.textColor) // Arama metni rengi
        .onChange(of: searchText) { _, result in
            Task {
                await viewModel.searchMovies(searchText: result)
            }
        }
    }
    
    // Kategorileri getir
    private func getAllCategories() -> [String] {
        let categories = Set(viewModel.moviesList.compactMap { $0.category })
        return ["Tümü"] + categories.sorted()
    }
    
    // Kategoriye göre filmleri filtrele
    private func getMoviesByCategory(_ category: String) -> [Movies] {
        if category == "Tümü" {
            return viewModel.moviesList
        }
        return viewModel.moviesList.filter { $0.category == category }
    }
}

#Preview {
    MainScreen()
}
