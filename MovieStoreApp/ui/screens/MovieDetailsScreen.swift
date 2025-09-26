//
//  MovieDetailsScreen.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import SwiftUI

struct MovieDetailsScreen: View {
    var movie: Movies
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MovieDetailsViewModel()
    @StateObject private var favoritesVM = FavoritesViewModel()
    @State private var quantity = 1
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image ?? "")")) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .fill(AppColors.textColor2.opacity(0.3))
                        .frame(height: 400)
                        .overlay(ProgressView())
                }
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(movie.name ?? "İsimsiz Film")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.textColor)
                        
                        Spacer()
                        
                        Button(action: {
                            if favoritesVM.isFavorite(movie: movie) {
                                _ = favoritesVM.removeFromFavorites(movieId: movie.id ?? 0)
                            } else {
                                _ = favoritesVM.addToFavorites(movie: movie)
                            }
                        }) {
                            Image(systemName: favoritesVM.isFavorite(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(favoritesVM.isFavorite(movie: movie) ? AppColors.mainColor : AppColors.textColor2)
                                .font(.title2)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("\(movie.year ?? 0)")
                        }
                        
                        HStack {
                            Image(systemName: "film")
                            Text(movie.category ?? "Kategori yok")
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                            Text("2h 46m")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(AppColors.textColor2)
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating ?? 0))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(AppColors.textColor)
                        
                        Spacer()
                        
                        Text("\(movie.price ?? 0) TL")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColors.mainColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textColor)
                        
                        Text(movie.description ?? "Açıklama bulunamadı.")
                            .font(.body)
                            .foregroundColor(AppColors.textColor)
                            .lineSpacing(4)
                    }
                    
                    HStack {
                        Text("Yönetmen:")
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.textColor)
                        Text(movie.director ?? "Bilinmiyor")
                            .foregroundColor(AppColors.textColor)
                    }
                    .font(.subheadline)
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    Divider()
                        .background(AppColors.textColor2.opacity(0.3))
                    
                    HStack {
                        Text("Adet:")
                            .fontWeight(.medium)
                            .foregroundColor(AppColors.textColor)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if quantity > 1 { quantity -= 1 }
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(AppColors.mainColor)
                                    .font(.title2)
                            }
                            .disabled(viewModel.isLoading)
                            
                            Text("\(quantity)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(minWidth: 30)
                                .foregroundColor(AppColors.textColor)
                            
                            Button(action: {
                                if quantity < 10 { quantity += 1 }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(AppColors.mainColor)
                                    .font(.title2)
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.addToCart(movie: movie, quantity: quantity)
                        }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "cart.badge.plus")
                                Text("Sepete Ekle")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isLoading ? AppColors.textColor2 : AppColors.mainColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
            }
        }
        .background(AppColors.background.ignoresSafeArea())
        .navigationTitle("Film Detayı")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Geri")
                    }
                    .foregroundColor(AppColors.mainColor)
                }
            }
        }
        .alert("Bilgi", isPresented: $viewModel.showAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .onAppear {
            favoritesVM.loadFavorites()
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailsScreen(movie: Movies())
    }
}
