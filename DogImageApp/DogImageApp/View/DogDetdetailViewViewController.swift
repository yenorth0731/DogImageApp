//
//  DogDetdetailViewViewController.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/19.
//

import UIKit
import Alamofire
import AlamofireImage

class DogDetdetailViewViewController: UIViewController {

    @IBOutlet weak var DogDetailImage: UIImageView!
    var imageUrl: String?
    var selectedBreed: String = "" // 犬種の名前を格納するプロパティ

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedBreed)
        navigationItem.title = selectedBreed

        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            DogDetailImage.af.setImage(withURL: url)
        }
    }
}
    

