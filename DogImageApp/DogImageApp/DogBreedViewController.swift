//
//  DogBreedViewController.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/19.
//

import UIKit

class DogBreedViewController: UIViewController {

    var selectedBreed: String = ""
    var breedImages: [String] = []
    
    
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
        CollectionView.delegate = self


        fetchImages(for: selectedBreed)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetail",
            let selectedImageUrl = sender as? String,
            let destinationVC = segue.destination as? DogDetdetailViewViewController {
             destinationVC.imageUrl = selectedImageUrl
         }
     }
    
    
    func fetchImages(for breed: String) {
        let urlString = "https://dog.ceo/api/breed/\(breed)/images"
        guard let requestUrl = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: requestUrl) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let imageUrls = json?["message"] as? [String] {
                    self?.breedImages = imageUrls
                    
//                    print("Fetched breedImages: \(self?.breedImages ?? [])") // 画像URLの配列が入ってる

                    DispatchQueue.main.async {
                        self?.CollectionView.reloadData()
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

}


extension DogBreedViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DogBreedCollectionViewCell
        
        let imageUrlString = breedImages[indexPath.item]
        if let imageUrl = URL(string: imageUrlString) {
            // 画像を非同期でダウンロードして表示
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        cell.configure(with: image)
                    }
                }
            }
        }
        
        return cell
    }
    
}

extension DogBreedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImageUrl = breedImages[indexPath.item]
        print("Selected Image URL: \(selectedImageUrl)") // デバッグ用にURLをプリント
        performSegue(withIdentifier: "showDetail", sender: selectedImageUrl)
    }
}
