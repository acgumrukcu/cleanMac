//
//   CacheCleaner.swift
//  CleanMac
//
//  Created by Ahmet Can Gümrükçü on 21.03.2025.
//

import Foundation

struct CacheCleaner {
    static func cleanUserCaches() -> (success: Bool, deletedFiles: [String]) {
        let fileManager = FileManager.default
        let cacheDirectory = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Caches")

        var deleted: [String] = []

        do {
            let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            
            for file in contents {
                do {
                    try fileManager.removeItem(at: file)
                    deleted.append(file.lastPathComponent)
                } catch {
                    print("❌ Dosya silinemedi: \(file.lastPathComponent)")
                }
            }

            return (true, deleted)
        } catch {
            print("🚫 Klasör okunamadı: \(error.localizedDescription)")
            return (false, [])
        }
    }
}
