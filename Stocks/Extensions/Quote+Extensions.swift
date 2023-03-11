//
//  Quote+Extensions.swift
//  Stocks
//
//  Created by Federico Lupotti on 05/03/23.
//

import Foundation
import StocksAPI

extension Quote {
    
    var regularPriceText: String? {
        Utils.format(value: regularMarketPrice)
    }
    
    var regularDiffText: String? {
        guard let text = Utils.format(value: regularMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
}
