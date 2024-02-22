import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TabBarに表示するView Controllerを作成
        let dogListViewController = DogListViewController()
        
        // View Controllerにタイトルを設定
        dogListViewController.title = "Dogs"
        
        // View Controllerにナビゲーションコントローラーを埋め込む
        let dogListNavigationController = UINavigationController(rootViewController: dogListViewController)

        
        // TabBarにView Controllerを追加
        self.viewControllers = [dogListNavigationController]
    }
}
