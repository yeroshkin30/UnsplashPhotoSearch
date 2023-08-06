//
//  TabBarController.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 18.05.2023.
//

import UIKit

final class MainFlowController: UITabBarController {

    let networkService: NetworkService = .init()
    lazy var authController: AuthorizationController = .init(networkService: networkService)

    var profileTabVC: ProfileTabVC!

    private let searchTabFlowController: SearchTabFlowController = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {

        profileTabVC = ProfileTabVC(with: authController)
        
        viewControllers = [searchTabFlowController, UINavigationController(rootViewController: profileTabVC)]

        tabBar.backgroundColor = .Unsplash.dark3
        tabBar.unselectedItemTintColor = .white
    }
}

extension MainFlowController {
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
