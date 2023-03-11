//
//  EmpyStateView.swift
//  Stocks
//
//  Created by Federico Lupotti on 04/03/23.
//

import SwiftUI

struct EmpyStateView: View {
    
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.headline)
                .foregroundColor(Color(uiColor: .secondaryLabel))
            Spacer()
        }
        .padding(64)
        .lineLimit(3)
        .multilineTextAlignment(.center)
    }
}

struct EmpyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmpyStateView(text: "No data aviable")
    }
}
