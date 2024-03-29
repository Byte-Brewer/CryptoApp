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
    @State var showLaunchScreen: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(.theme.accent)]
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                }
                .environmentObject(vm)
                .tint(.theme.accent)
                
                ZStack {
                    if showLaunchScreen {
                        LaunchView(showLaunchScreen: $showLaunchScreen)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            
        }
    }
}
