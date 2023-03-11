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
    
    @Published var tickers: [Ticker] = []
    @Published var subtitleText: String
    var emptyTickersText = "Search & add symbols to see stock quotes"
    var titleText = "Stocks"
    let attributionText = "Powered by Yahoo! finance API"
    
    init() {
        self.subtitleText = subtitleDateFormatter.string(from: Date())
    }
    
    private let subtitleDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMM"
        return df
    }()
    
    func removeTickers(atOffsets offsets: IndexSet) {
        tickers.remove(atOffsets: offsets)
    }
    
    func openYahooFinance() {
        let url = URL(string: "https://finance.yahoo.com")!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    
}
