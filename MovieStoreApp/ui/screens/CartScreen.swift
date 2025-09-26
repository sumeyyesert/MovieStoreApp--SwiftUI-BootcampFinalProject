//
//  CartScreen.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 23.09.2025.
//

import SwiftUI

struct CartScreen: View {
    @StateObject private var viewModel = CartViewModel()
    
    var cartTotal: Int {
        var total = 0
        for item in viewModel.cartItems {
            let price = item.price ?? 0
            let quantity = item.orderAmount ?? 1
            total += price * quantity
        }
        return total
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Sepet yükleniyor...")
                        .foregroundColor(AppColors.textColor)
                } else if viewModel.cartItems.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.mainColor
                            )
                        
                        Text("Sepetiniz boş")
                            .font(.title2)
                            .foregroundColor(AppColors.textColor)
                        
                        Text("Henüz sepete film eklemediniz")
                            .font(.body)
                            .foregroundColor(AppColors.textColor2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppColors.background)
                } else {
                    VStack {
                        List {
                            ForEach(viewModel.cartItems) { item in
                                CartListItem(item: item)
                                    .listRowBackground(AppColors.background) // Liste hücre arkaplanı
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            Task {
                                                if let cartId = item.cartId {
                                                    await viewModel.deleteFromCart(cartId: cartId)
                                                }
                                            }
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(AppColors.background) // Liste arkaplanı
                        
                        VStack(spacing: 16) {
                            Divider()
                                .background(AppColors.textColor2)
                            
                            HStack {
                                Text("Toplam:")
                                    .font(.headline)
                                    .foregroundColor(AppColors.textColor)
                                
                                Spacer()
                                
                                Text("\(cartTotal) TL")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(AppColors.mainColor) // Ana renk
                            }
                            .padding(.horizontal)
                            
                            Button(action: {
                                print("Satın alındı! Toplam: \(cartTotal) TL")
                            }) {
                                HStack {
                                    Image(systemName: "creditcard.fill")
                                    Text("Satın Al")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.mainColor) // Ana renk
                                .foregroundColor(AppColors.textColor) // Yazı rengi
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        }
                        .background(AppColors.background) // Alt bölüm arkaplanı
                    }
                }
            }
            .navigationTitle("Sepetim")
            .navigationBarTitleDisplayMode(.large)
            .background(AppColors.background) // Ana arkaplan
            .onAppear {
                Task {
                    await viewModel.loadCart()
                }
            }
        }
    }
}

#Preview {
    CartScreen()
}
