//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Nazar Prysiazhnyi on 07.03.2023.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    
    @State private var vm: HomeViewModel = .init()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
            
        }
    }
}
