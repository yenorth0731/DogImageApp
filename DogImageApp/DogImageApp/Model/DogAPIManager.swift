import Foundation
import UIKit

class DogAPIManager {
    static func fetchDogBreeds(completion: @escaping (Result<[DogBreed], Error>) -> Void) {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.badHTTPResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let breedsDict = json?["message"] as? [String: [String]] {
                    let breeds = breedsDict.map { DogBreed(name: $0.key, images: $0.value.map { DogImage(imageUrl: $0) }) }
                    completion(.success(breeds))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func fetchImages(for breed: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "https://dog.ceo/api/breed/\(breed)/images"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            handleDataResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }
    
    static func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            handleDataResponse(data: data, response: response, error: error) { (result: Result<Data, Error>) in
                switch result {
                case .success(let imageData):
                    guard let image = UIImage(data: imageData) else {
                        completion(.failure(NetworkError.invalidData))
                        return
                    }
                    completion(.success(image))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private static func handleDataResponse<T>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(NetworkError.badHTTPResponse))
            return
        }
        
        guard data != nil else {
            completion(.failure(NetworkError.noData))
            return
        }
        
        
    }
}
