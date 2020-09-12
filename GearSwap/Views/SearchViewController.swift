//
//  SearchViewController.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/10/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

protocol SearchViewProtocol: class {
    func update(itemViewModel: [ItemViewModel])
    func update(status: String?)
}

struct ItemViewModel {
    let name: String
    let price: String
    let seller: String
    let imageURL: String
}

class SearchViewController: UIViewController {
    @IBOutlet private (set) var collectionView: UICollectionView!
    @IBOutlet private (set) var searchBar: UISearchBar!
    @IBOutlet private (set) var statusView: UIView!
    @IBOutlet private (set) var statusLabel: UILabel!

    private let sectionInsets = UIEdgeInsets(top: 24.0, left: 8.0, bottom: 24.0, right: 8.0)
    private let itemsPerRow: CGFloat = 2

    var presenter = SearchPresenter()
    var items = [ItemViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attach(self)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionViewCellID")

        searchBar.delegate = self

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension SearchViewController: SearchViewProtocol {
    func update(itemViewModel: [ItemViewModel]) {
        items = itemViewModel
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    func update(status: String?) {
        if let status = status {
            DispatchQueue.main.async {
                self.statusView.isHidden = false
                self.statusLabel.text = status
            }
        } else {
            DispatchQueue.main.async {
                self.statusView.isHidden = true
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCellID", for: indexPath) as! ItemCollectionViewCell
        let item = items[indexPath.row]

        cell.configure(title: item.name, price: item.price, seller: item.seller, imageURL: item.imageURL)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let thirdToLastIndex = items.count - 3
        if indexPath.row == thirdToLastIndex {
            presenter.getSearchResults()
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = 1.5 * widthPerItem

        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return sectionInsets.left
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.clearPreviousSearch()
        presenter.getSearchResults(searchBar.text)
        dismissKeyboard()
    }
}
