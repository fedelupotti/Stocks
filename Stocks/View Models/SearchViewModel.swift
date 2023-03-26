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
    var isSearching: Bool { !trimmedQuery.isEmpty }
    var emptyMessage: String {
        "There are any symbol \n\"\(query)\""
    }
    
    private let stocksApi: StocksApi
    private var cancellables = Set<AnyCancellable>()
    
    init(query: String = "", stocksApi: StocksApi = StocksAPI()) {
        self.query = query
        self.stocksApi = stocksApi
        
        startObserving()
    }
    
    private func startObserving() {
        $query
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink { _ in
                Task { [weak self] in await self?.searchTickers() }
            }
            .store(in: &cancellables)
        
        $query
            .filter { $0.isEmpty }
            .sink { [weak self] _ in self?.phase = .initial }
            .store(in: &cancellables)
    }
    
    func searchTickers() async {
        let searchQuery = trimmedQuery
        guard !searchQuery.isEmpty else { return }
        phase = .fetching
        
        do {
            let tickers = try await stocksApi.searchTickers(query: searchQuery, isEquityTypeOnly: true)
            if searchQuery != trimmedQuery { return }
            if tickers.isEmpty {
                phase = .empty
            } else {
                phase = .success(tickers)
            }
            
        }
        catch {
            if searchQuery != trimmedQuery { return }
            phase = .failure(error)
            print(error.localizedDescription)
            
        }
    }
}
