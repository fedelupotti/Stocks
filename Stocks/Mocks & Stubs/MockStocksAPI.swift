//
//  MockStocksAPI.swift
//  Stocks
//
//  Created by Federico Lupotti on 18/03/23.
//

import Foundation
import StocksAPI

#if DEBUG

struct MockStocksAPI: StocksApi {
    
    var stubbedSearchTickersCallBack: (() async throws -> [Ticker])!
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker] {
        try await stubbedSearchTickersCallBack()
    }
    
    var stubbedFetchQuotesCallBack: (() async throws -> [Quote])!
    func fetchQuotes(symbols: String) async throws -> [Quote] {
        try await stubbedFetchQuotesCallBack()
    }
}

#endif
