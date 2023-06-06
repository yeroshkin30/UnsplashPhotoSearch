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

    let textField: UITextField = .init()
    var onTextChange: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        contentView.backgroundColor = .systemGray4
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    @objc func textDidChange(_ sender: UITextField) {
        sender.text.map { onTextChange?($0) }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textField.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).offset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configuration(holder: String, text: String?) {
        textField.placeholder = holder
        textField.text = text
    }
}
