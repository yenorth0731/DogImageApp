import UIKit
import Alamofire
import AlamofireImage

class DogDetdetailViewViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageUrl: String = ""
    var selectedBreed: String = ""
    var imageView = UIImageView()
    
    
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
        // 画像のダウンロードと設定
        if let url = URL(string: imageUrl) {
            imageView.contentMode = .scaleAspectFit
            imageView.af.setImage(withURL: url)
            imageView.frame = CGRect(origin: .zero, size: scrollView.bounds.size)
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.bounds.size
        }
    }
    
    @objc func doubleTapHandler(_ gesture: UITapGestureRecognizer) {
        // ナビゲーションバーの表示/非表示をトグルする
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
