//
//  Constants.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/14/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

struct Constants {
    struct API {
        static let url = "https://api.staging.sidelineswap.com/v1/facet_items"
        static let queryParameter = "q"
        static let pageParameter = "page"
    }

    struct Business {
        static let searchBarPlaceholder = "Search for new and used gear"
        static let alertConfirmButton = "Okay"
    }

    struct ErrorHandling {
        static let defaultErrorMessage = "Sorry, something went wrong. Please try again."
        static let emptyResults = "No results matching your search. Please try again."
    }

    struct CollectionViewCells {
        static let itemCollectionViewCellName = "ItemCollectionViewCell"
        static let itemCollectionViewCellIdentifier = "ItemCollectionViewCellID"
    }
}
