//
//  UIButton.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 05.08.2023.
//

import UIKit

extension UIButton.Configuration {
    static func clear() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .zero
        config.baseForegroundColor = .white
        config.background = .clear()
        config.baseBackgroundColor = .clear

        return config
    }
}
extension UIButton {
    func onTapEvent(event: UIControl.Event = .touchUpInside, handler: @escaping () -> Void) {
        addAction(UIAction { _ in
            handler()
        }, for: event)
    }
}
