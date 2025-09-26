//
//  MovieGridCard.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 21.09.2025.
//

import SwiftUI

struct MovieGridCard: View {
    var movie: Movies
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image ?? "")")) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width / 2) - 24, height: 280)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                Rectangle()
                    .fill(AppColors.background.opacity(0.5))
                    .frame(width: (UIScreen.main.bounds.width / 2) - 24, height: 280)
                    .cornerRadius(12)
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.5)
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.name ?? "İsimsiz")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(AppColors.textColor)
                    .lineLimit(1)
                
                HStack {
                    Text("\(movie.price ?? 0) TL")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppColors.mainColor)
                    
                    Spacer()
                    
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 10))
                        Text(String(format: "%.1f", movie.rating ?? 0))
                            .font(.system(size: 11))
                            .foregroundColor(AppColors.textColor2)
                    }
                }
                
                Text(movie.category ?? "Kategori yok")
                    .font(.system(size: 11))
                    .foregroundColor(AppColors.textColor2)
                    .lineLimit(1)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .background(AppColors.background)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.mainColor.opacity(0.2), lineWidth: 1) 
        )
        .padding(4)
    }
}

#Preview {
    MovieGridCard(movie: Movies())
}
