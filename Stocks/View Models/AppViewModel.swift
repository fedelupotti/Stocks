//
//  AppViewModel.swift
//  Stocks
//
//  Created by Federico Lupotti on 04/03/23.
//

import Foundation
import SwiftUI
import StocksAPI

@MainActor // So all properties can be updated inside the main thread
class AppViewModel: ObservableObject {
    
    @Published var tickers: [Ticker] = [] {
        didSet {
            self.saveTickers()
        }
    }
    @Published var subtitleText: String
    var emptyTickersText = "Search & add symbols to see stock quotes"
    var titleText = "Stocks"
    let attributionText = "Powered by Yahoo! finance API"
    
    let tickerListRepository: TickerListRepository
    
    init(repository: TickerListRepository = TickerPlistRepository()) {
        self.tickerListRepository = repository
        self.subtitleText = subtitleDateFormatter.string(from: Date())
        self.loadTickers()
    }
    
    private func loadTickers() {

        Task { [weak self] in
            
            guard let self else { return }
            do {
                self.tickers = try await self.tickerListRepository.load()
            }
            catch {
                print(error.localizedDescription)
                self.tickers = []
            }
        }
    }
    
    private func saveTickers() {
        
        Task { [weak self] in
            
            guard let self else { return }
            do {
                try await self.tickerListRepository.save(self.tickers)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private let subtitleDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMM"
        return df
    }()
    
    func removeTickers(atOffsets offsets: IndexSet) {
        tickers.remove(atOffsets: offsets)
    }
    
    func isAddedToMyTickers(_ ticker: Ticker) -> Bool {
         tickers.contains(where: { $0.symbol == ticker.symbol } )
    }
    
    func toggleTicker(_ ticker: Ticker) {
        if isAddedToMyTickers(ticker) {
            removeToMyTickers(ticker)
        } else {
            addToMyTickers(ticker)
        }
    }
    
    private func removeToMyTickers(_ ticker: Ticker) {
        guard let index = tickers.firstIndex(where: { $0.symbol == ticker.symbol } ) else { return }
        tickers.remove(at: index)
    }
    
    private func addToMyTickers(_ ticker: Ticker) {
        tickers.append(ticker)
    }
    
    func openYahooFinance() {
        let url = URL(string: "https://finance.yahoo.com")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    
}
