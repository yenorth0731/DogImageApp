//
//  FavoriteAPIManeger.swift
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
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
            }
            try data.write(to: fileURL)
            print("Favorites saved successfully.")
        } catch {
            print("Error saving favorites:", error)
        }
    }
    
    static func addFavorite(_ newFavorite: Favorite) {
        if var favorites = loadFavorites() {
            favorites.append(newFavorite)
            print("Favorite JSON:", try? JSONEncoder().encode(favorites))
            saveFavorites(favorites)
        } else {
            print("New Favorite JSON:", try? JSONEncoder().encode([newFavorite]))
            saveFavorites([newFavorite])
        }
    }

    private static func getFilePath() throws -> URL {
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
