//
//  ErrorStateView.swift
//  Stocks
//
//  Created by Federico Lupotti on 04/03/23.
//

import SwiftUI

struct ErrorStateView: View {
    
    let error: String
    var retryCallback: (() -> ())? = nil
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                Text(error)
                if let retryCallback {
                    Button("Retry", action: retryCallback)
                        .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .padding(64)
    }
}

struct ErrorStateView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            ErrorStateView(error: "An error ocurred") {}
                .previewDisplayName("With Retry Button")
            
            ErrorStateView(error: "An Error ocurred")
                .previewDisplayName("Without Retry Button")
        }
    }
}
