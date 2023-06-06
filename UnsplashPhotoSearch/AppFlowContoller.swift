//
//  TabBarController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit

class AppFlowController: UITabBarController {

    let networkService: NetworkService = .init()
    lazy var authController: AuthorizationController = .init(networkService: networkService)

    var profileTabVC: ProfileTabVC!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        let searchVC = SearchVC()

        profileTabVC = ProfileTabVC(with: authController)
        
        viewControllers = [UINavigationController(rootViewController: searchVC), UINavigationController(rootViewController: profileTabVC)]

        tabBar.backgroundColor = .Unsplash.dark3
        tabBar.unselectedItemTintColor = .white
    }
}

extension AppFlowController {
//    func showEditProfileVC(with user: User) {
//        let editProfileVC = EditProfileVC(network: networkService, user: user)
//        editProfileVC.onEvent = { [weak self] event in
//            switch event {
//            case .save(let user):
//                print("Save")
//            case .cancel:
//                print("cancel")
//            }
//        }
//        show(UINavigationController(rootViewController: editProfileVC), sender: nil)
//    }
//
//    enum events {
//        case photoSelect
//        case collectionSelect
//        case userSelected
//    }
}
