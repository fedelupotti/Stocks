//
//  SearchViewModel.swift
//  Stocks
//
//  Created by Federico Lupotti on 11/03/23.
//

import Foundation
import Combine
import SwiftUI
import StocksAPI

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published var phase: FetchPhase<[Ticker]> = .initial
    
    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var tickers: [Ticker] { phase.value ?? [] }
    var error: Error? { phase.error }
    var isSearching: Bool { !trimmedQuery.isEmpty}
}
