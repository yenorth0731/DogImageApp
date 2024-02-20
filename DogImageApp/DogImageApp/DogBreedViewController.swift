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
    var dogAPIManager = DogAPIManager()
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
        CollectionView.delegate = self
        fetchImages(for: selectedBreed)
//        print(selectedBreed)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showDetail",
            let selectedImageUrl = sender as? String,
            let destinationVC = segue.destination as? DogDetdetailViewViewController {
             destinationVC.imageUrl = selectedImageUrl
             print("Selected image URL: \(selectedImageUrl)") // デバッグ用にURLをプリント

         }
     }

    
      
      func fetchImages(for breed: String) {
          DogAPIManager.fetchImages(for: breed) { [weak self] result in
              switch result {
              case .success(let imageUrls):
                  self?.breedImages = imageUrls
                  DispatchQueue.main.async {
                      self?.CollectionView.reloadData()
                  }
              case .failure(let error):
                  print("Error fetching images: \(error.localizedDescription)")
              }
          }
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
              DogAPIManager.downloadImage(from: imageUrl) { result in
                  switch result {
                  case .success(let image):
                      DispatchQueue.main.async {
                          cell.configure(with: image)
                      }
                  case .failure(let error):
                      print("Error downloading image: \(error.localizedDescription)")
                  }
              }
          }
          
          return cell
      }
  }

  extension DogBreedViewController: UICollectionViewDelegate {
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          let selectedImageUrl = breedImages[indexPath.item]
          performSegue(withIdentifier: "showDetail", sender: selectedImageUrl)
      }
  }
