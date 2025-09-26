//
//  TabBarView.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 21.09.2025.
//

import SwiftUI

struct TabBarView: View {
    init() {
        // TabBar görünümünü özelleştir
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Arkaplan rengi
        appearance.backgroundColor = UIColor(AppColors.cardBackground)
        
        // Seçili olmayan item rengi
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textColor2)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppColors.textColor2)]
        
        // Seçili item rengi
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.mainColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppColors.mainColor)]
        
        // Standart ve scroll edge appearance'ı ayarla
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            // 1. Ana Sayfa
            MainScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Ana Sayfa")
                }
                .tag(0)
            
            // 2. Beğendiklerim
            FavoritesScreen()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorilerim")
                }
                .tag(1)
            
            // 3. Sepetim
            CartScreen()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Sepetim")
                }
                .tag(2)
            
            // 4. Profilim
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profil")
                }
                .tag(3)
        }
        .accentColor(AppColors.mainColor)
        .background(AppColors.background)
    }
}

#Preview {
    TabBarView()
}
