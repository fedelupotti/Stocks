//
//  Stubs.swift
//  Stocks
//
//  Created by Federico Lupotti on 04/03/23.
//

import Foundation
import StocksAPI

#if DEBUG
extension Ticker {
    
    static var stubs: [Ticker] {
        [
        Ticker(symbol: "APPL", quoteType: nil, shortname: "Apple Inc.", longname: nil, sector: nil, industry: nil, exchDisp: nil),
        Ticker(symbol: "TSLA", quoteType: nil, shortname: "Tesla", longname: nil, sector: nil, industry: nil, exchDisp: nil),
        Ticker(symbol: "NVDA", quoteType: nil, shortname: "Nvidia Corp.", longname: nil, sector: nil, industry: nil, exchDisp: nil),
        Ticker(symbol: "AMD", quoteType: nil, shortname: "Advanced Micro Device", longname: nil, sector: nil, industry: nil, exchDisp: nil)
        ]
    }
}

extension Quote {
    
    static var stubs: [Quote] {
        [
            Quote(symbol: "APPL", regularMarketPrice: 150.43, regularMarketChange: -2.41),
            Quote(symbol: "TSLA", regularMarketPrice: 250.10, regularMarketChange: 5.1),
            Quote(symbol: "NVDA", regularMarketPrice: 179.57, regularMarketChange: -0.79),
            Quote(symbol: "AMD", regularMarketPrice: 181.09, regularMarketChange: 3.14),
        ]
    }
    
    static var stubsDict: [String: Quote] {
        var dict = [String: Quote]()
        stubs.forEach { dict[$0.symbol] = $0 }
        return dict
    }
}

#endif
