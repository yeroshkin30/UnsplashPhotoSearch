//
//  TabBarController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit

class UnsplashTabBarController: UITabBarController {

    let networkService: NetworkService = .init()
    let authController: AuthorizationController = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let searchVC = SearchVC()
        let searchTabItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        searchVC.tabBarItem = searchTabItem

        let profileTabVC = ProfileTabVC(with: authController)


        let profileTabItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        profileTabVC.tabBarItem = profileTabItem
        profileTabVC.onEvent = { user in

        }
        viewControllers = [UINavigationController(rootViewController: searchVC), UINavigationController(rootViewController: profileTabVC)]

        tabBar.backgroundColor = .Unsplash.dark3
        tabBar.unselectedItemTintColor = .white
    }
}

extension UnsplashTabBarController {

}
