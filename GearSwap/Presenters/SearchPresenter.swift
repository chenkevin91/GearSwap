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
    private let session: URLSessionProtocol

    func attach(_ view: SearchViewProtocol?) {
        self.view = view
    }

    init(session: URLSessionProtocol) {
        self.session = session
    }

    func getSearchResults(_ item: String? = nil, fromRefreshControl: Bool = false) {
        var urlComponent = URLComponents(string: Constants.API.url)
        if item == nil, let previousItem = previousSearchedItem, let page = page {
            guard hasNextPage || fromRefreshControl else {
                return
            }
            let itemQueryItem = URLQueryItem(name: Constants.API.queryParameter, value: previousItem)
            let pageQueryItem = URLQueryItem(name: Constants.API.pageParameter, value: String(page+1))
            urlComponent?.queryItems = fromRefreshControl ? [itemQueryItem] : [itemQueryItem, pageQueryItem]
        } else {
            urlComponent?.queryItems = [URLQueryItem(name: Constants.API.queryParameter, value: item)]
            previousSearchedItem = item
        }

        if let url = urlComponent?.url, !isSearchRequestRunning {
            isSearchRequestRunning = true
            session.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Search Request Error: \(error?.localizedDescription ?? "missing error")")
                    self.isSearchRequestRunning = false
                    self.view?.update(status: Constants.ErrorHandling.defaultErrorMessage)
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
                    if searchResponse.data.isEmpty {
                        self.view?.update(status: Constants.ErrorHandling.emptyResults)
                    } else {
                        self.view?.update(itemViewModel: self.itemViewModels)
                    }
                    
                } else {
                    self.isSearchRequestRunning = false
                    self.view?.update(status: Constants.ErrorHandling.defaultErrorMessage)
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

    func clearItems() {
        items = []
        itemViewModels = []
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
