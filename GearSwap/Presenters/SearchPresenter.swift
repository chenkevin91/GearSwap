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
    private var items = [Item]()
    private var itemViewModels = [ItemViewModel]()
    private var previousSearchedItem: String?
    private var page: Int?
    private var hasNextPage = false
    private var isSearchRequestRunning = false

    func attach(_ view: SearchViewProtocol?) {
        self.view = view
    }

    func getSearchResults(_ item: String? = nil) {
        var urlComponent = URLComponents(string: "https://api.staging.sidelineswap.com/v1/facet_items")
        if item == nil, let previousItem = previousSearchedItem, let page = page {
            guard hasNextPage else {
                return
            }
            let itemQueryItem = URLQueryItem(name: "q", value: previousItem)
            let pageQueryItem = URLQueryItem(name: "page", value: String(page+1))
            urlComponent?.queryItems = [itemQueryItem, pageQueryItem]
        } else {
            urlComponent?.queryItems = [URLQueryItem(name: "q", value: item)]
            previousSearchedItem = item
        }

        if let url = urlComponent?.url, !isSearchRequestRunning {
            isSearchRequestRunning = true
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Search Request Error: \(error?.localizedDescription ?? "missing error")")
                    self.isSearchRequestRunning = false
                    return
                }

                if let searchResponse = self.parseSearchResponse(data) {
                    self.page = searchResponse.meta.paging.page
                    self.hasNextPage = searchResponse.meta.paging.has_next_page

                    self.items = self.items + searchResponse.data
                    searchResponse.data.forEach { item in
                        self.itemViewModels.append(ItemViewModel(name: item.name,
                                                                 price: item.price.formattedToCurrency(),
                                                                 seller: item.seller.username,
                                                                 imageURL: item.primary_image.thumb_url))
                    }
                    self.isSearchRequestRunning = false
                    self.view?.update(itemViewModel: self.itemViewModels)
                    self.view?.update(status: searchResponse.data.isEmpty ? "No results, please try again" : nil)
                    
                    print(searchResponse.data.first?.name ?? "no results")
                    print(searchResponse.data.first?.price ?? "no results")
                    print(searchResponse.data.count)
                }
            }.resume()
        }
    }

    func clearPreviousSearch() {
        items = []
        itemViewModels = []
        previousSearchedItem = nil
        page = nil
    }

    private func parseSearchResponse(_ data: Data) -> SearchResponse? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(SearchResponse.self, from: data)
        } catch {
            print("Parse Error: \(error)")
            return nil
        }
    }
}
