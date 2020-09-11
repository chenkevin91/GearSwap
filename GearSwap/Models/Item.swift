//
//  Item.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/11/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

struct Item: Codable {
    let id: Int
    let state: String?
    let name: String
    let category_1: String?
    let category_2: String?
    let price: Double
    let list_price: Double
    let url: String?
    let favoriters_count: Int
    let favorite: String?
    let sync_gmc: Bool
    let created_at: String
    let updated_at: String
    let label: String?
    let actions: [String]
    let categories: [Category]
    let images: [Image]
    let seller: Seller
    let primary_image: Image
}

struct Category: Codable {
    let id: Int
    let uuid: String
    let slug: String
    let name: String
    let full_name: String
    let relatable: Bool
    let show_popular_models: Bool
    let icon_url: String?
    let image_url: String?
    let has_models: Bool
    let title_name: String
    let shipping_hint: String?
    let url: String
}
