//
//  FavoriteListViewController.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/22.
//

import UIKit

class FavoriteCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    //    var dogImage: DogImage?
    //    var breed: DogBreed?
    var dogImages: [String] = []
    var hoge = ["affenpinscher": "https://images.dog.ceo/breeds/affenpinscher/n02110627_3144.jpg",
                "akita":"https://images.dog.ceo/breeds/akita/512px-Akita_inu.jpg",
                "beagle":"https://images.dog.ceo/breeds/beagle/n02088364_14663.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchFavoriteDogImages()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteDetail" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first,
               let destinationVC = segue.destination as? DogDetdetailViewViewController {
                let selectedImageUrlString = dogImages[selectedIndexPath.item]
                if let selectedImageUrl = URL(string: selectedImageUrlString) {
                    destinationVC.dogImage = DogImage(imageUrl: selectedImageUrl.absoluteString)
                }
            }
        }
    }
        
        private func fetchFavoriteDogImages() {
            let dogBreeds = Array(hoge.keys)
            dogImages = dogBreeds.compactMap { hoge[$0] }
        }
    
}




extension FavoriteCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteCollectionViewCell
        
        let imageUrlString = dogImages[indexPath.item]
        
        
        if let imageUrl = URL(string: imageUrlString) {
            cell.imageCell.af.setImage(withURL: imageUrl, completion: { response in
                if case .success(let image) = response.result {
                    // 画像をトリミングして正方形にする
                    let scaledImage = image.af.imageAspectScaled(toFill: cell.imageCell.bounds.size)
                    cell.imageCell.image = scaledImage
                }
            })
            
        }
        return cell
    }
}

//extension FavoriteCollectionViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedBreed = Array(hoge.keys)[indexPath.item]
//        let selectedImageUrlString = dogImages[indexPath.item]
//
//        }
//    }


extension FavoriteCollectionViewController: UICollectionViewDelegateFlowLayout {
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
