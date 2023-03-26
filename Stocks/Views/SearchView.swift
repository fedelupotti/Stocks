//
//  SearchView.swift
//  Stocks
//
//  Created by Federico Lupotti on 11/03/23.
//

import SwiftUI
import StocksAPI

@MainActor
struct SearchView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @ObservedObject var searchVM: SearchViewModel
    @StateObject var quotesVM = QuotesViewModel()
    
    var body: some View {
        
        List(searchVM.tickers) { ticker in
            TickerListRowView(
                data: .init(symbol: ticker.symbol,
                            name: ticker.shortname,
                            price: quotesVM.priceForTicker(ticker),
                            type: .search(
                                isSaved: appVM.isAddedToMyTickers(ticker),
                                onButtonTapped: {
                                    Task { @MainActor in
                                        appVM.toggleTicker(ticker)
                                    }                     
                                }
                            )
                           )
            )
        }
        .listStyle(.plain)
        .refreshable {
            await quotesVM.fetchQuotes(tickers: searchVM.tickers)
        }
        .task(id: searchVM.tickers) {
            await quotesVM.fetchQuotes(tickers: searchVM.tickers)
        }
        .overlay { listSearchOverlay }
    }
    
    @ViewBuilder
    private var listSearchOverlay: some View {
        switch searchVM.phase {
        case .failure(let error):
            ErrorStateView(error: error.localizedDescription, retryCallback: {
                Task {
                    await searchVM.searchTickers()
                }
            } )
        case .empty:
            EmpyStateView(text: searchVM.emptyMessage)
        case .fetching:
            LoadingStateView()
        default: EmptyView()
        }
    }
    
}



struct SearchView_Previews: PreviewProvider {
    
    @StateObject static var stubbedSearchVM: SearchViewModel = {
        let searchVM = SearchViewModel()
        searchVM.phase = .success(Ticker.stubs)
        return searchVM
    }()
    
    @StateObject static var emptySearchVM: SearchViewModel = {
        let searchVM = SearchViewModel()
        searchVM.query = "Moveler"
        searchVM.phase = .empty
        return searchVM
    }()
    
    @StateObject static var errorSearchVM: SearchViewModel = {
        let searchVM = SearchViewModel()
        searchVM.phase = .failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"An error has been occured"]))
        return searchVM
    }()
    
    @StateObject static var loadingSearchVM: SearchViewModel = {
        let searchVM = SearchViewModel()
        searchVM.phase = .fetching
        return searchVM
    }()
    
    @StateObject static var appVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Array(Ticker.stubs.prefix(upTo: 2))
        return vm
    }()
    
    static var QuotesVM: QuotesViewModel = {
        let vm = QuotesViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
    }()
    
    static var previews: some View {
        
        Group {
            NavigationStack {
                SearchView(searchVM: stubbedSearchVM, quotesVM: QuotesVM)
            }
            .searchable(text: $stubbedSearchVM.query)
            .previewDisplayName("Results")
            
            NavigationStack {
                SearchView(searchVM: emptySearchVM, quotesVM: QuotesVM)
            }
            .searchable(text: $emptySearchVM.query)
            .previewDisplayName("Empty")
            
            NavigationStack {
                SearchView(searchVM: errorSearchVM, quotesVM: QuotesVM)
            }
            .searchable(text: $errorSearchVM.query)
            .previewDisplayName("Error")
            
            NavigationStack {
                SearchView(searchVM: loadingSearchVM, quotesVM: QuotesVM)
            }
            .searchable(text: $loadingSearchVM.query)
            .previewDisplayName("Loading")
        }
        .environmentObject(appVM)
    }
}
