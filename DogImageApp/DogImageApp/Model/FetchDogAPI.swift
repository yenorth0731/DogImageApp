//
//  fetchDogAPI.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/16.
//

import UIKit

class FetchDogAPI{
    
    func feachData(){
        let urlString = "https://dog.ceo/api/breeds/list/all"

        guard let requestUrl = URL(string: urlString) else {
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: requestUrl) { (data, res,error) in
            if let error = error {
                print("Unexpected error: \(error.localizedDescription). ")
                return
            }
            //HTTPresエラー
            if let res = res as? HTTPURLResponse {
                if !(200...299).contains(res.statusCode) {
                    print("Request Failed - Status Code: \(res.statusCode).ß")
                    return
                }
            }
            
            //データ型　JSONに
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let breeds = json?["message"] as? [String: [String]] {
                        for breed in breeds.keys {
                            // breedをUTF-8文字列に変換して利用
                            if let breedData = breed.data(using: .utf8),
                               let breedString = String(data: breedData, encoding: .utf8) {
                                print(breedString)
                            }
                        }
                        
                    } else {
                        print("jsonError :(String(describing: jsonDict))")
                    }
                } catch {
                    print("Error")
                }
            } else {
                print("Unexpected error.")
            }

        }
    }
    
    
    
    
    
    
}
