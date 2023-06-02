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
    var isLoadingFlag = false 

    init (controller: DataRequestController<ItemType>) {
        self.dataRequestController = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
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

    func loadNextPage(with index: IndexType) {
        let startIndex = searchData.count

        isLoadingFlag = true


        Task {
            do {

                let searchData = try await dataRequestController.loadNextPage()
                self.searchData.append(contentsOf: searchData)
            } catch {
                print(error)
            }

            if searchData.count > startIndex {
                let itemRange = Array(startIndex...self.searchData.count - 1)

                switch index {
                case .item:
                    let insertedIndexRange = itemRange.map { IndexPath(item: $0, section: 0) }
                    collectionView.insertItems(at: insertedIndexRange)
                case.section:
                    let itemRange = Array(startIndex...self.searchData.count - 1)
                    collectionView.insertSections(IndexSet(itemRange))
                }

            }
            
            isLoadingFlag = false
        }
    }

    enum IndexType {
        case section
        case item
    }
}
