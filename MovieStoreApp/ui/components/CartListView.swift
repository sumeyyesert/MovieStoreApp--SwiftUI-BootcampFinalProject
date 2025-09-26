//
//  CartListItem.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import SwiftUI

struct CartListItem: View {
    var item: MovieCart
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(item.image ?? "")")) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
            } placeholder: {
                Rectangle()
                    .fill(AppColors.background.opacity(0.3)) // Arkaplan rengiyle uyumlu
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name ?? "İsimsiz")
                    .font(.headline)
                    .foregroundColor(AppColors.textColor) // Ana yazı rengi
                
                Text("Adet: \(item.orderAmount ?? 1)")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textColor2) // İkincil yazı rengi
                
                Text("Toplam: \((item.price ?? 0) * (item.orderAmount ?? 1)) TL")
                    .font(.subheadline)
                    .foregroundColor(AppColors.mainColor) // Ana renk (fiyat vurgusu)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(AppColors.background) // Kart arkaplan rengi
        .cornerRadius(12)
        .padding(.horizontal, 4)
    }
}

#Preview {
    CartListItem(item: MovieCart())
        .background(AppColors.background) // Preview'da da arkaplanı göster
}
