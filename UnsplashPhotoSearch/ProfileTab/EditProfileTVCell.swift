//
//  EditProfileTVCell.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 26.05.2023.
//

import UIKit
import SnapKit

class EditProfileTVCell: UITableViewCell {
    static let identifier = "EditProfileTVCell"

    private let textField: UITextField = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = contentView.frame
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configuration(holder: String) {
        textField.placeholder = holder
    }
}
