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
    
    var body: some View {
        tickerListView
            .listStyle(.plain)
            .overlay { overlayView }
            .toolbar {
                titleToolBar
                attributionToolBar
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
            }//
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    
    @StateObject static var appVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = Ticker.stubs
        return vm
    }()
    
    @StateObject static var emptyAppVM: AppViewModel = {
        let vm = AppViewModel()
        vm.tickers = []
        return vm
    }()
    
    @StateObject static var quotesVM: QuotesViewModel = {
        let vm = QuotesViewModel()
        vm.quotesDict = Quote.stubsDict
        return vm
    }()
    
    
    static var previews: some View {
        
        Group {
            NavigationStack {
                MainListView(quotesVM: quotesVM)
            }
            .environmentObject(appVM)
            .previewDisplayName("With Tickers")
            
            NavigationStack {
                MainListView(quotesVM: quotesVM)
            }
            .environmentObject(emptyAppVM)
            .previewDisplayName("Without Tickers")
        }
    }
}
