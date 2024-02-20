import Foundation


class DogAPIManager {
    
    static func fetchData(completion: @escaping ([String]?, Error?) -> Void) {
        let urlString = "https://dog.ceo/api/breeds/list/all"
        
        guard let requestUrl = URL(string: urlString) else {
            completion(nil, NSError(domain: "InvalidURL", code: -1, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "RequestFailed", code: -1, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "NoDataReceived", code: -1, userInfo: nil))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let breedsDict = json?["message"] as? [String: [String]] {
                    let breeds = Array(breedsDict.keys)
                    completion(breeds, nil)
                } else {
                    completion(nil, NSError(domain: "FailedToParseJSON", code: -1, userInfo: nil))
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    
    static func fetchImages(for breed: String, completion: @escaping (Result<[String], Error>) -> Void) {
           let urlString = "https://dog.ceo/api/breed/\(breed)/images"
           guard let requestUrl = URL(string: urlString) else {
               completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
               return
           }
           
           let task = URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                   completion(.failure(NSError(domain: "RequestFailed", code: -1, userInfo: nil)))
                   return
               }
               
               guard let data = data else {
                   completion(.failure(NSError(domain: "NoDataReceived", code: -1, userInfo: nil)))
                   return
               }
               
               do {
                   let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                   if let imageUrls = json?["message"] as? [String] {
                       completion(.success(imageUrls))
                   } else {
                       completion(.failure(NSError(domain: "FailedToParseJSON", code: -1, userInfo: nil)))
                   }
               } catch {
                   completion(.failure(error))
               }
           }
           task.resume()
       }
}
