//
//  SafariCleaner.swift
//  CleanMac
//
//  Created by Ahmet Can Gümrükçü on 21.03.2025.
//

import Foundation
import AppKit

struct SafariCleaner {
    static func cleanSafariData() -> (success: Bool, deletedItems: [String]) {
        let fileManager = FileManager.default
        var deleted: [String] = []

        // 1. Safari geçmiş dosyası
        let historyDB = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Safari/History.db")
        if fileManager.fileExists(atPath: historyDB.path) {
            do {
                try fileManager.removeItem(at: historyDB)
                deleted.append("History.db")
            } catch {
                print("🚫 Geçmiş silinemedi: \(error.localizedDescription)")
            }
        }

        // 2. Safari cache klasörü
        let safariCache = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Caches/com.apple.Safari")
        if fileManager.fileExists(atPath: safariCache.path) {
            do {
                let contents = try fileManager.contentsOfDirectory(at: safariCache, includingPropertiesForKeys: nil)
                for file in contents {
                    try fileManager.removeItem(at: file)
                    deleted.append(file.lastPathComponent)
                }
            } catch {
                print("🚫 Cache temizlenemedi: \(error.localizedDescription)")
            }
        }

        return (!deleted.isEmpty, deleted)
    }
    
    static func selectAndCleanSafariHistory() -> (Bool, [String]) {
        let panel = NSOpenPanel()
        panel.title = "Select Safari Folder"
        panel.message = "Please select the Safari folder to clean history"
        panel.prompt = "Select"
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK, let selectedURL = panel.url {
            return cleanHistory(at: selectedURL)
        }

        return (false, [])
    }

    private static func cleanHistory(at folderURL: URL) -> (Bool, [String]) {
        let fileManager = FileManager.default
        var deleted: [String] = []

        let historyDB = folderURL.appendingPathComponent("History.db")
        if fileManager.fileExists(atPath: historyDB.path) {
            do {
                try fileManager.removeItem(at: historyDB)
                deleted.append("History.db")
            } catch {
                print("❌ Could not delete History.db: \(error.localizedDescription)")
            }
        }

        return (!deleted.isEmpty, deleted)
    }
    
    static func getSafariCacheSize() -> Double {
        let fileManager = FileManager.default
        let cacheURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Caches/com.apple.Safari")
        var totalSize: UInt64 = 0

        guard let enumerator = fileManager.enumerator(at: cacheURL, includingPropertiesForKeys: [.fileSizeKey]) else {
            return 0
        }

        for case let fileURL as URL in enumerator {
            do {
                let attributes = try fileURL.resourceValues(forKeys: [.fileSizeKey])
                if let fileSize = attributes.fileSize {
                    totalSize += UInt64(fileSize)
                }
            } catch {
                print("⚠️ Dosya boyutu okunamadı: \(error)")
            }
        }

        // Sonucu MB olarak döndür
        return Double(totalSize) / (1024 * 1024)
    }
}
