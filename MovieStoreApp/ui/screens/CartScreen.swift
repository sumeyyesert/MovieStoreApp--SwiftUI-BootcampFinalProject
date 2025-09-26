//
//  CartScreen.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import SwiftUI

struct CartScreen: View {
    @StateObject private var viewModel = CartViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Sepet yükleniyor...")
                        .foregroundColor(AppColors.textColor)
                } else if viewModel.cartItems.isEmpty {
                    emptyCartView
                } else {
                    cartListView
                }
            }
            .navigationTitle("Sepetim")
            .navigationBarTitleDisplayMode(.large)
            .background(AppColors.background)
            .onAppear {
                Task {
                    await viewModel.loadCart()
                }
            }
        }
    }

    private var emptyCartView: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart.fill")
                .font(.system(size: 60))
                .foregroundColor(AppColors.mainColor)
            
            Text("Sepetiniz boş")
                .font(.title2)
                .foregroundColor(AppColors.textColor)
            
            Text("Henüz sepete film eklemediniz")
                .font(.body)
                .foregroundColor(AppColors.textColor2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
    }

    private var cartListView: some View {
        VStack {
            
            List {
                ForEach(viewModel.groupedItems, id: \.movie.name) { groupedItem in
                    GroupedCartListItem(
                        movie: groupedItem.movie,
                        totalQuantity: groupedItem.totalQuantity
                    ) {
                        
                        Task {
                            await viewModel.deleteSingleItem(movieName: groupedItem.movie.name ?? "")
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.deleteAllItems(movieName: groupedItem.movie.name ?? "")
                            }
                        } label: {
                            Label("Tümünü Sil", systemImage: "trash.fill")
                        }
                    }
                    .listRowBackground(AppColors.background)
                }
            }
            .listStyle(PlainListStyle())
            .background(AppColors.background)

            checkoutSection
        }
    }

    private var checkoutSection: some View {
        VStack(spacing: 16) {
            Divider()
                .background(AppColors.textColor2.opacity(0.3))
            
            HStack {
                Text("Toplam:")
                    .font(.headline)
                    .foregroundColor(AppColors.textColor)
                
                Spacer()
                
                Text("\(viewModel.calculateTotalPrice()) TL")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.mainColor)
            }
            .padding(.horizontal)
            
            Button(action: {
                print("Satın alındı! Toplam: \(viewModel.calculateTotalPrice()) TL")
            }) {
                HStack {
                    Image(systemName: "creditcard.fill")
                    Text("Satın Al")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColors.mainColor)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .background(AppColors.cardBackground)
    }
}

#Preview {
    CartScreen()
}
