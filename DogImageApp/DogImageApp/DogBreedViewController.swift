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

    var dogImage: DogImage?
    var breed: DogBreed?
    var imageView = UIImageView()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = breed?.name
        fetchImages(for: breed?.name ?? "")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
               let destinationVC = segue.destination as? DogDetdetailViewViewController {
                if let selectedBreed = breed,
                   selectedIndexPath.item < selectedBreed.images.count {
                    let selectedImageUrl = selectedBreed.images[selectedIndexPath.item].imageUrl
                    destinationVC.dogImage = DogImage(imageUrl: selectedImageUrl)
                    destinationVC.selectedBreed = selectedBreed.name
                }
            }
        }
    }
    
    func fetchImages(for breedName: String) {
        DogAPIManager.fetchImages(for: breedName) { [weak self] result in
            switch result {
            case .success(let imageUrls):
                let dogImages = imageUrls.map { DogImage(imageUrl: $0) }
                self?.breed = DogBreed(name: breedName, images: dogImages)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching images: \(error)")
            }
        }
    }
}

extension DogBreedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breed?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DogBreedCollectionViewCell
        
        if let breed = breed, indexPath.item < breed.images.count {
            let imageUrlString = breed.images[indexPath.item].imageUrl
            if let imageUrl = URL(string: imageUrlString) {
                // 画像を非同期でダウンロードして表示
                cell.DogImages.af.setImage(withURL: imageUrl, completion: { response in
                    if case .success(let image) = response.result {
                        // 画像をトリミングして正方形にする
                        let scaledImage = image.af.imageAspectScaled(toFill: cell.DogImages.bounds.size)
                        cell.DogImages.image = scaledImage
                    }
                })
            }
        }
        
        return cell
    }
}

extension DogBreedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // セルの幅と高さを同じに設定することで、正方形のセルを作成する
        let cellWidth = (collectionView.frame.width - 1) / 2 // 2枚の画像を表示するために、横幅を半分にする
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // セル間の水平方向の余白を1に設定する
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1 // セル間の垂直方向の余白を1に設定する
    }
}
