//
//  MainListView.swift
//  Stocks
//
//  Created by Federico Lupotti on 23/02/23.
//

import SwiftUI
import StocksAPI

struct MainListView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM = QuotesViewModel()
    @StateObject var searchVM = SearchViewModel()
    
    var body: some View {
        tickerListView
            .listStyle(.plain)
            .overlay { overlayView }
            .toolbar {
                titleToolBar
                attributionToolBar
            }
            .searchable(text: $searchVM.query)
            .refreshable {
                await quotesVM.fetchQuotes(tickers: appVM.tickers)
            }
            .task(id: appVM.tickers) {
                await quotesVM.fetchQuotes(tickers: appVM.tickers)
            }
    }
    
    private var tickerListView: some View {
        List {
            ForEach(appVM.tickers) { ticker in
                TickerListRowView(data: .init(
                    symbol: ticker.symbol,
                    name: ticker.shortname,
                    price: quotesVM.priceForTicker(ticker),
                    type: .main))
                .contentShape(Rectangle())
                .onTapGesture { }
            }
            .onDelete { appVM.removeTickers(atOffsets: $0) }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        if appVM.tickers.isEmpty {
            EmpyStateView(text: appVM.emptyTickersText)
        }
        if searchVM.isSearching {
            SearchView(searchVM: searchVM)
        }
    }
    
    private var titleToolBar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            VStack(alignment: .leading, spacing: -4) {
                Text(appVM.titleText)
                Text(appVM.subtitleText)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            .font(.title2.weight(.heavy))
            .padding(.bottom)
        }
    }
    
    private var attributionToolBar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    appVM.openYahooFinance()
                } label: {
                    Text(appVM.attributionText)
                        .font(.caption.weight(.heavy))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    
    @StateObject static var appVM: AppViewModel = {
        var mock = MockTickerRepository()
        mock.stubbedLoad = { Ticker.stubs }
        return AppViewModel(repository: mock)
    }()
    
    @StateObject static var emptyAppVM: AppViewModel = {
        var mock = MockTickerRepository()
        mock.stubbedLoad = { [] }
        return AppViewModel(repository: mock)
    }()
    
    static var quotesVM: QuotesViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedFetchQuotesCallBack = { Quote.stubs }
        return QuotesViewModel(stocksApi: mock)
    }()
    
    static var searchVM: SearchViewModel = {
        var mock = MockStocksAPI()
        mock.stubbedSearchTickersCallBack = { Ticker.stubs }
        return SearchViewModel(stocksApi: mock)
    }()
    
    
    static var previews: some View {
        
        Group {
            NavigationStack {
                MainListView(quotesVM: quotesVM, searchVM: searchVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("With Tickers")
            
            NavigationStack {
                MainListView(quotesVM: quotesVM, searchVM: searchVM)
            }
            .environmentObject(emptyAppVM)
            .previewDisplayName("Without Tickers")
        }
    }
}
