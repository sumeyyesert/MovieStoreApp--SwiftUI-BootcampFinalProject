//
//  TabBarView.swift
//  MovieStoreApp
//
//  Created by Sümeyye Sert on 21.09.2025.
//

import SwiftUI

struct TabBarView: View {
    init() {

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = UIColor(AppColors.cardBackground)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textColor2)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(AppColors.textColor2)]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.mainColor)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppColors.mainColor)]
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            MainScreen()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Ana Sayfa")
                }
                .tag(0)

            FavoritesScreen()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorilerim")
                }
                .tag(1)
            
            CartScreen()
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Sepetim")
                }
                .tag(2)
            
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
