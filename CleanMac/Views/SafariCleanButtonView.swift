//
//  SafariCleanButtonView.swift
//  CleanMac
//
//  Created by Ahmet Can Gümrükçü on 21.03.2025.
//

import SwiftUI

struct SafariCleanButtonView: View {
    @State private var result: String = ""
    @State private var cacheSize: Double = 0
    
    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                var resultData: (Bool, [String]) = (false, [])
                resultData = SafariCleaner.selectAndCleanSafariHistory()
                if resultData.0 {
                    result = "✅ Safari geçmişi silindi: \(resultData.1.count) dosya"
                } else {
                    result = "🚫 Silme işlemi iptal edildi veya başarısız"
                }
            }) {
                Text("Clean Safari History (Manual)")
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if !result.isEmpty {
                Text(result)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(String(format: "Safari cache boyutu: %.1f MB", cacheSize))
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .onAppear {
            cacheSize = SafariCleaner.getSafariCacheSize()
        }
        .padding()
    }
}
