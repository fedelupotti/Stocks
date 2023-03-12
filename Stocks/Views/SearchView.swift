//
//  SearchView.swift
//  Stocks
//
//  Created by Federico Lupotti on 11/03/23.
//

import SwiftUI
import StocksAPI

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
                                    appVM.toggleTicker(ticker)})))
        }
        .listStyle(.plain)
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
        vm.tickers = Ticker.stubs
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
            .environmentObject(appVM)
            .previewDisplayName("Results")
            
            NavigationStack {
                SearchView(searchVM: emptySearchVM, quotesVM: QuotesVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("Empty")
            
            NavigationStack {
                SearchView(searchVM: errorSearchVM, quotesVM: QuotesVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("Error")
            
            NavigationStack {
                SearchView(searchVM: loadingSearchVM, quotesVM: QuotesVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("Loading")
        }
    }
}
