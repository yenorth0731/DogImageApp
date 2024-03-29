import UIKit
import Alamofire
import AlamofireImage



class DogDetdetailViewViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dogImage: DogImage?
    var selectedBreed: String = ""
    var imageUrl: URL?
    var imageView = UIImageView()
    var favoriteManager = FavoriteAPIManager()


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4.0
        scrollView.minimumZoomScale = 1.0
        
        navigationItem.title = selectedBreed
        setImageView()

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(_:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(doubleTap)
    }
    
    func setImageView() {
        guard let dogImage = dogImage else { return }
        if let url = URL(string: dogImage.imageUrl) {
            imageView.contentMode = .scaleAspectFit
            imageView.af.setImage(withURL: url)
            imageView.frame = CGRect(origin: .zero, size: scrollView.bounds.size)
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.bounds.size
        }
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        // URLがnilでないことを確認
        guard let imageUrlString = dogImage?.imageUrl, let imageUrl = URL(string: imageUrlString) else {
            print("Image URL is nil")
            return
        }

        // 新しいFavoriteオブジェクトを作成
        let newFavorite = Favorite(breed: selectedBreed, imageURL: imageUrl.absoluteString, isFavorite: true)

        // Favorite.jsonに新しいデータを追加
        FavoriteAPIManager.addFavorite(newFavorite)
    }

    
    
    
    @objc func doubleTapHandler(_ gesture: UITapGestureRecognizer) {
        let isNavBarHidden = navigationController?.isNavigationBarHidden ?? false
        navigationController?.setNavigationBarHidden(!isNavBarHidden, animated: true)
        
        let newScale = scrollView.zoomScale < 3.0 ? 3.0 : 1.0
        let zoomRect = zoomRectFor(scale: newScale, center: gesture.location(in: gesture.view))
        scrollView.zoom(to: zoomRect, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func zoomRectFor(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect()
        zoomRect.size.width = scrollView.frame.size.width / scale
        zoomRect.size.height = scrollView.frame.size.height / scale
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        return zoomRect
    }
}
