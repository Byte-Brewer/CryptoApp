//
//  HomeView.swift
//  CryptoApp
//
//  Created by Nazar Prysiazhnyi on 07.03.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPorfolio: Bool = false  // animate right
    @State private var showPorfolioView: Bool = false // new sheet
    
    var body: some View {
        ZStack {
            // background Layer
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showPorfolioView, onDismiss: {
                    showPorfolioView = false
                }) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            // content layer
            VStack {
                homeHeader
                HomeStatisticView(showPorfolio: $showPorfolio)
                SearchBarView(searchText: $vm.searchText)
                
                columnTitle
                if !showPorfolio {
                    allCoinList
                        .transition(.move(edge: .leading))
                }
                if showPorfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .toolbar(.hidden)
        }
        .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPorfolio ? "plus" : "info")
                .animation(.none, value: 0)
                .onTapGesture {
                    if showPorfolio {
                        showPorfolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPorfolio)
                )
            Spacer()
            Text(showPorfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPorfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPorfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitle: some View {
        HStack {
            Text("Coin")
            Spacer()
            if showPorfolio {
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
}
