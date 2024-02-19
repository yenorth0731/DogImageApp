//
//  DogDetdetailViewViewController.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/19.
//

import UIKit

class DogDetdetailViewViewController: UIViewController {

    @IBOutlet weak var DogDetailImage: UIImageView!
    var imageUrl: String?
    var selectedBreed: String = "しば犬" // 犬種の名前を格納するプロパティ


    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedBreed
        
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            // 画像をダウンロードして表示する
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self?.DogDetailImage.image = UIImage(data: data)
                }
            }.resume()
        
    }
           }
        // Do any additional setup after loading the view.
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
