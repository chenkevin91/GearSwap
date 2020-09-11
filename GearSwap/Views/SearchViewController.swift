//
//  SearchViewController.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/10/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import UIKit

protocol SearchViewProtocol: class {}

class SearchViewController: UIViewController {
    @IBOutlet private (set) var collectionView: UICollectionView!
    @IBOutlet private (set) var searchBar: UISearchBar!

    var presenter = SearchPresenter()

    private let sectionInsets = UIEdgeInsets(top: 24.0, left: 8.0, bottom: 24.0, right: 8.0)
    private let itemsPerRow: CGFloat = 2

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

extension SearchViewController: SearchViewProtocol {}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 125
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCellID", for: indexPath) as! ItemCollectionViewCell

        return cell
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
        presenter.getSearchResults(with: "")
        view.endEditing(true)
    }

//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        view.endEditing(true)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    }

}
