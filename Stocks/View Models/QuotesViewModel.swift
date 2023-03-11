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
    
    func priceForTicker(_ ticker: Ticker) -> PriceChange? {
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
              let change = quote.regularDiffText
        else { return nil }
        return (price, change)
    }
}
