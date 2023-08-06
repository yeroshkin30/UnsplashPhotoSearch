//
//  ViewController+Extension.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 27.05.2023.
//

import UIKit

extension UIViewController {

    func addChild (controller: UIViewController, rootView: UIView) {
        addChild(controller)
        rootView.addSubview(controller.view)
        controller.didMove(toParent: self)
        controller.view.layout(in: rootView)

    }

    func removeChildVC(_ viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()

    }
}

extension UIViewController {
    func childrenFullScreenAnimatedTransition(
        from presented: UIViewController,
        to presenting: UIViewController,
        completion: ((Bool) -> Void)? = nil
    ) {
        assert(presented.parent == self, "Presented view controller should be a child of self", file: #file, line: #line)

        presented.willMove(toParent: nil)
        addChild(presenting)
        presenting.view.alpha = 0
        presenting.view.layout(in: view)
        presenting.didMove(toParent: self)

        UIView.animate(
            withDuration: 0.3,
            animations: {
                presenting.view.alpha = 1
            }, completion: { isFinished in

                presented.view.removeFromSuperview()
                presented.removeFromParent()

                completion?(isFinished)
            }
        )
    }
}

