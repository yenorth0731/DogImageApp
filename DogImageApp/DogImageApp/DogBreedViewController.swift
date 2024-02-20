//
//  DogBreedViewController.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/19.
//

import UIKit
import Alamofire
import AlamofireImage

class DogBreedViewController: UIViewController {

    var selectedBreed: String = ""
    var breedImages: [String] = []
    
    
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectionView.dataSource = self
//        CollectionView.delegate = self
        navigationItem.title = selectedBreed


        fetchImages(for: selectedBreed)

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let selectedIndexPath = CollectionView.indexPathsForSelectedItems?.first,
               let destinationVC = segue.destination as? DogDetdetailViewViewController {
                let selectedImageUrl = breedImages[selectedIndexPath.item]
                destinationVC.imageUrl = selectedImageUrl
                destinationVC.selectedBreed = self.selectedBreed
                //private使ったら
                //navigationtitleの値ってどうする
            }
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
                print("Error fetching images: \(error)")
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
            // 画像を非同期でダウンロードして表示
            cell.DogImages.af.setImage(withURL: imageUrl)
        }
        
        return cell
    }
}
