//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Nazar Prysiazhnyi on 07.03.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // update allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .milliseconds(500) , scheduler: RunLoop.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // update portfolio
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // update marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            return coin.name.contains(lowercasedText)
            || coin.symbol.contains(lowercasedText)
            || coin.id.contains(lowercasedText)
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { coin in
            guard let entitiy = portfolioCoins.first(where: { $0.coinID == coin.id }) else { return nil }
            return coin.updateHoldings(amount: entitiy.amount)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap",
                                       value: data.marketCap,
                                       percentageChange: data.marketCapChangePercentage24HUsd)
        let volum = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        let previousValue = portfolioCoins.map({ coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChanges = (coin.priceChangePercentage24H ?? 0.0) / 100
            let previousValue = currentValue / (1 + percentChanges)
            return previousValue
        }).reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue ) * 100
        let portfolio = StatisticModel(title: "Portfolio Value",
                                       value: portfolioValue.asCurrencyWith2Decimals(),
                                       percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volum, btcDominance, portfolio])
        return stats
    }
}
