import UIKit
import Alamofire
import AlamofireImage

class DogDetdetailViewViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageUrl: String?
    var selectedBreed: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedBreed
        //画像実装
    }
    
}
