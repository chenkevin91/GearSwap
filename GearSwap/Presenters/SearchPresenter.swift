//
//  SearchPresenter.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/11/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

class SearchPresenter {
    weak var view: SearchViewProtocol?

    func attach(_ view: SearchViewProtocol?) {
        self.view = view
    }

    func getSearchResults(with searchParameter: String) {
        let urlString = "https://api.staging.sidelineswap.com/v1/facet_items?q=nike%20bag&page=2"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Request Error: \(error?.localizedDescription ?? "missing error")")
                    return
                }

                if let searchResponse = self.parseSearchResponse(data) {
                    print(searchResponse.data[0].name)
                    print(searchResponse.data.count)
                }

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
