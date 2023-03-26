//
//  QuotesViewModel.swift
//  Stocks
//
//  Created by Federico Lupotti on 04/03/23.
//

import Foundation
import SwiftUI
import StocksAPI

// VM for fetch de Quote data given a ticker array
// Responsable for store the tickers added for the users

@MainActor
class QuotesViewModel: ObservableObject {
    
    @Published var quotesDict: [String: Quote] = [:]
    private let stocksApi: StocksApi
    
    init(stocksApi: StocksApi = StocksAPI()) {
        self.stocksApi = stocksApi
    }
    
    func fetchQuotes(tickers: [Ticker]) async {
        guard !tickers.isEmpty else { return }
        
        do {
            let symbols = tickers.map { $0.symbol }.joined(separator: ",")
            let quotes = try await stocksApi.fetchQuotes(symbols: symbols)
            var dict = [String: Quote]()
            quotes.forEach({ dict[$0.symbol] = $0 })
            self.quotesDict = dict
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    func priceForTicker(_ ticker: Ticker) -> PriceChange? {
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
              let change = quote.regularDiffText
        else { return nil }
        return (price, change)
    }
}
