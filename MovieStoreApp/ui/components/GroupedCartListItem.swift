//
//  GroupedCartListItem.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 27.09.2025.
//

import SwiftUI

struct GroupedCartListItem: View {
    var movie: MovieCart
    var totalQuantity: Int
    var onDeleteSingle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image ?? "")")) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(AppColors.background.opacity(0.3))
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                    .overlay(ProgressView())
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.name ?? "İsimsiz")
                    .font(.headline)
                    .foregroundColor(AppColors.textColor)
                    .lineLimit(1)
                
                Text("Kategori: \(movie.category ?? "Bilinmiyor")")
                    .font(.caption)
                    .foregroundColor(AppColors.textColor2)
                
                HStack {
                    Text("Adet: \(totalQuantity)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textColor2)
                    
                    Spacer()
     
                    if totalQuantity > 1 {
                        Button(action: onDeleteSingle) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(AppColors.mainColor)
                                .font(.title2)
                        }
                    }
                }
                
                Text("Toplam: \((movie.price ?? 0) * totalQuantity) TL")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.mainColor)
            }
            
            Spacer()
 
            Text("\(totalQuantity) adet")
                .font(.caption)
                .foregroundColor(AppColors.textColor2.opacity(0.7))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    GroupedCartListItem(
        movie: MovieCart(),
        totalQuantity: 2,
        onDeleteSingle: {}
    )
    .background(AppColors.background)
}
