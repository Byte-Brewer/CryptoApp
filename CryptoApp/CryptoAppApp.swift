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
