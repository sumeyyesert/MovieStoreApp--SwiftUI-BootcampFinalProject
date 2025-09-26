//
//  FavoritesScreen.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import SwiftUI

struct FavoritesScreen: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()
                
                Group {
                    if viewModel.favoriteMovies.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 60))
                                .foregroundColor(AppColors.mainColor)
                            
                            Text("Favori filminiz yok")
                                .font(.title2)
                                .foregroundColor(AppColors.textColor2)
                            
                            Text("Beğendiğiniz filmleri kalbe tıklayarak kaydedin")
                                .font(.subheadline)
                                .foregroundColor(AppColors.textColor2)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(viewModel.favoriteMovies) { movie in
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
            .navigationTitle("Favorilerim")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
}

#Preview {
    FavoritesScreen()
}
