//
//  FavoriteAPIManager.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/22.
//

import Foundation

struct Favorite: Codable {
    let breed: String
    let imageURL: String
    var isFavorite: Bool
}

class FavoriteAPIManager {
    private static let directoryName = "Favorites"
    private static let fileName = "favorite.json"
    
    static func loadFavorites() -> [Favorite]? {
        do {
            let fileURL = try getFilePath()
            let data = try Data(contentsOf: fileURL)
            let favorites = try JSONDecoder().decode([Favorite].self, from: data)
            return favorites
        } catch {
            print("Error reading JSON file:", error)
            return nil
        }
    }
    
    static func saveFavorites(_ favorites: [Favorite]) {
        do {
            let data = try JSONEncoder().encode(favorites)
            let fileURL = try getFilePath()
            try data.write(to: fileURL)
            print("Favorites saved successfully.")
            print("File path:", fileURL.path)
        } catch {
            print("Error saving favorites:", error)
        }
    }
    
    static func addFavorite(_ newFavorite: Favorite) {
        if var favorites = loadFavorites() {
            favorites.append(newFavorite)
            saveFavorites(favorites)
        } else {
            saveFavorites([newFavorite])
        }
    }
    
    static func getFilePath() throws -> URL {
        // アプリのドキュメントディレクトリを取得
        let libraryDirectory = try FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        // ファイル名を明示的に指定して追加
        let fileName = "favorite.json"
        let fileURL = libraryDirectory.appendingPathComponent(fileName)

        return fileURL
    }
}
