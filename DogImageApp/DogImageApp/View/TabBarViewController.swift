//
//  TabBarViewController.swift
//  DogImageApp
//
//  Created by spark-01 on 2024/02/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Listのビューコントローラーを取得して設定
        let listStoryboard = UIStoryboard(name: "Main", bundle: nil) // MainはStoryboardの名前に合わせて変更
        let listViewController = listStoryboard.instantiateViewController(withIdentifier: "DogListViewController") // Storyboard IDに合わせて変更
        listViewController.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "list_icon"), selectedImage: nil) // タブのアイコンとタイトルを設定
        
        // Favoriteのビューコントローラーを取得して設定
        let favoriteStoryboard = UIStoryboard(name: "Main", bundle: nil) // MainはStoryboardの名前に合わせて変更
        let favoriteViewController = favoriteStoryboard.instantiateViewController(withIdentifier: "FavoriteListViewController") // Storyboard IDに合わせて変更
        favoriteViewController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "favorite_icon"), selectedImage: nil) // タブのアイコンとタイトルを設定
        
        // UITabBarControllerにビューコントローラーを設定
        viewControllers = [listViewController, favoriteViewController]
    }

}
