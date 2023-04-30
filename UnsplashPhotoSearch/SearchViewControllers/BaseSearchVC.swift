//
//  BaseSearchVC.swift
//  UnsplashPhotoSearch
//
//  Created by Oleg  on 15.04.2023.
//

import UIKit

class BaseSearchVC<ItemType: Codable>: UIViewController {
    let collectionView = UICollectionView.initWithCells()
    let dataRequestController: DataRequestController<ItemType>
    var searchTask: Task<Void, Never>?
    var searchData: [ItemType] = []


    init (controller: DataRequestController<ItemType>) {
        self.dataRequestController = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fetchFirstPage() {
        searchTask?.cancel()
        searchTask = Task {
            do {
                self.searchData = try await dataRequestController.loadNextPage()
            } catch {
                print(error)
            }
            collectionView.reloadData()
            searchTask?.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }

    func searchWordDidChange(_ word: String) {
        if dataRequestController.searchWord != word {
            searchData = []
            collectionView.reloadData()
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            dataRequestController.searchWord = word
            fetchFirstPage()
        }
    }
}
