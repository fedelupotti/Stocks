//
//  StocksApp.swift
//  Stocks
//
//  Created by Federico Lupotti on 23/02/23.
//

import SwiftUI

@main
struct StocksApp: App {
    
    @StateObject var appVM = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainListView()
            }
            .environmentObject(appVM)
        }
    }
}
