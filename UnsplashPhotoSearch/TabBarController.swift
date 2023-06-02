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

    var profileTabVC: ProfileTabVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let searchVC = SearchVC()

        profileTabVC = ProfileTabVC(with: authController)
        profileTabVC.onEvent = { [weak self] user in
            self?.showEditProfileVC(with: user)
        }
        viewControllers = [UINavigationController(rootViewController: searchVC), UINavigationController(rootViewController: profileTabVC)]

        tabBar.backgroundColor = .Unsplash.dark3
        tabBar.unselectedItemTintColor = .white
    }
}

extension UnsplashTabBarController {
    func showEditProfileVC(with user: User) {
        let editProfileVC = EditProfileVC(network: networkService, user: user)
        editProfileVC.onEvent = { [weak self] event in
            switch event {
            case .save(let user):
                print("Save")
            case .cancel:
                print("cancel")
            }
        }
    }
}
