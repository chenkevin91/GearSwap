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
    func update(status: String)
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
    @IBOutlet private (set) var activityIndicator: UIActivityIndicatorView!

    private let sectionInsets = UIEdgeInsets(top: 24.0, left: 8.0, bottom: 24.0, right: 8.0)
    private let itemsPerRow: CGFloat = 2
    private let refreshControl = UIRefreshControl()

    var presenter = SearchPresenter(session: URLSession.shared)
    var items = [ItemViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attach(self)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Constants.CollectionViewCells.itemCollectionViewCellName, bundle: nil),
                                forCellWithReuseIdentifier: Constants.CollectionViewCells.itemCollectionViewCellIdentifier)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshSearch), for: .valueChanged)

        searchBar.delegate = self
        searchBar.placeholder = Constants.Business.searchBarPlaceholder

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func refreshSearch() {
        presenter.clearItems()
        presenter.getSearchResults(fromRefreshControl: true)
        dismissKeyboard()
    }
}

extension SearchViewController: SearchViewProtocol {
    func update(itemViewModel: [ItemViewModel]) {
        items = itemViewModel
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.collectionView.alpha = 1.0
            self.collectionView.reloadData()
        }
    }

    func update(status: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: status, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: Constants.Business.alertConfirmButton, style: .default, handler: nil)
            alert.addAction(okayAction)

            self.refreshControl.endRefreshing()
            self.activityIndicator.stopAnimating()
            self.collectionView.alpha = 1.0
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCells.itemCollectionViewCellIdentifier,
                                                      for: indexPath) as! ItemCollectionViewCell
        let item = items[indexPath.row]

        cell.configure(title: item.name, price: item.price, seller: item.seller, imageURL: item.imageURL)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let fifthToLastIndex = items.count - 5
        if indexPath.row == fifthToLastIndex {
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
        if !(searchBar.text?.isEmpty ?? true) {
            presenter.clearPreviousSearch()
            presenter.getSearchResults(searchBar.text)
            dismissKeyboard()

            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.collectionView.alpha = 0.15
            }
        }
    }
}
