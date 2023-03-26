//
//  StocksAPI.swift
//  Stocks
//
//  Created by Federico Lupotti on 13/03/23.
//

import Foundation
import StocksAPI

protocol StocksApi {
    func searchTickers(query: String, isEquityTypeOnly: Bool) async throws -> [Ticker]
    func fetchQuotes(symbols: String) async throws -> [Quote]
}

extension StocksAPI: StocksApi {}
