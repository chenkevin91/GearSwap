//
//  SearchPresenter.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/11/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation
import UIKit

class SearchPresenter {
    weak var view: SearchViewProtocol?
    var items = [Item]()
    var itemViewModels = [ItemViewModel]()

    func attach(_ view: SearchViewProtocol?) {
        self.view = view
    }

    func getSearchResults(with searchParameter: String) {
        let urlString = "https://api.staging.sidelineswap.com/v1/facet_items?q=nike%20bag&page=2"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Search Request Error: \(error?.localizedDescription ?? "missing error")")
                    return
                }

                if let searchResponse = self.parseSearchResponse(data) {
                    self.items = self.items + searchResponse.data
                    searchResponse.data.forEach { item in
                        self.itemViewModels.append(ItemViewModel(name: item.name,
                                                                 price: item.price.formattedToCurrency(),
                                                                 seller: item.seller.username,
                                                                 image: nil))
                    }
                    self.view?.update(itemViewModel: self.itemViewModels)
                    
                    print(searchResponse.data[0].name)
                    print(searchResponse.data.count)
                }

            }.resume()
        }
    }

    func getImage(for index: Int) {
        let item = items[index]
        let urlString = item.primary_image.thumb_url
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Image Request Error: \(error?.localizedDescription ?? "missing error")")
                    return
                }

                self.itemViewModels[index].image = UIImage(data: data)
                self.view?.update(itemViewModel: self.itemViewModels)

            }.resume()
        }
    }

    private func parseSearchResponse(_ data: Data) -> SearchResponse? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(SearchResponse.self, from: data)
        } catch {
            print("Parese Error: \(error)")
            return nil
        }
    }
}
