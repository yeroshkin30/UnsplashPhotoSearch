//
//  TabBarController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit

class UnsplashTabBarController: UITabBarController {

    let searchVC: SearchVC = {
        let vc = SearchVC()
        let sys = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        vc.tabBarItem = sys

        return vc
    }()

    let authorizationVC: AuthorizationVC = {
        let vc = AuthorizationVC()
        let sys = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        vc.tabBarItem = sys

        return vc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [UINavigationController(rootViewController: searchVC), UINavigationController(rootViewController: authorizationVC)]
    }
}
