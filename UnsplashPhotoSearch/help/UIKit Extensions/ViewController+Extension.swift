//
//  ViewController+Extension.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 27.05.2023.
//

import UIKit

extension UIViewController {
    func addChildVC(_ viewController: UIViewController, superView: UIView? = nil) {
        addChild(viewController)

        if let superView = superView as? UIStackView {
            superView.addArrangedSubview(viewController.view)
        } else if let superView {
            superView.addSubview(viewController.view)
        } else {
            view.addSubview(viewController.view)
        }
        viewController.didMove(toParent: self)
    }
    
    func removeChildVC(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()

    }
}
