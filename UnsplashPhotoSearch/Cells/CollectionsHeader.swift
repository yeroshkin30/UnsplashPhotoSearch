//
//  CollectionsHeader.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 30.03.2023.
//

import UIKit

final class CollectionsHeaderView: UICollectionReusableView {
    
    private let nameLabel: UILabel = .init()
    private let numberOfPhotosLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(name: String, number: String) {
        nameLabel.text = name
        numberOfPhotosLabel.text = number
    }
}

private extension CollectionsHeaderView {
    func setupView(){
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(numberOfPhotosLabel)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading

        stackView.layout(in: self) {
            $0.top == topAnchor + 12
            $0.leading == leadingAnchor + 8
        }

        setupLabels()
    }

    func setupLabels() {
        nameLabel.textColor = .label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        numberOfPhotosLabel.textColor = .label
        numberOfPhotosLabel.font = UIFont.systemFont(ofSize: 11)
    }
}

final class SectionBackgroundColor: UICollectionReusableView {
    private let view: UIView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = .systemGray2.withAlphaComponent(0.15)
        view.layer.cornerRadius = 5
        view.layout(in: self, allEdges: 5)
    }
}
