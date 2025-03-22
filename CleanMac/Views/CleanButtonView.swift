//
//  CleanButtonView.swift
//  CleanMac
//
//  Created by Ahmet Can Gümrükçü on 21.03.2025.
//

import SwiftUI

struct CleanButtonView: View {
    @State private var cleanResult: String = ""

    var body: some View {
        VStack(spacing: 10) {
            Button(action: {
                let result = CacheCleaner.cleanUserCaches()
                if result.success {
                    cleanResult = "🧹 Silinen dosya sayısı: \(result.deletedFiles.count)"
                } else {
                    cleanResult = "🚫 Temizlik başarısız oldu"
                }
            }) {
                Text("Clean Cache")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if !cleanResult.isEmpty {
                Text(cleanResult)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}
