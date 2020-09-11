//
//  Meta.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/11/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

struct Meta: Codable {
    let query: Query
    let facets: [Facet]
    let paging: Paging
}

struct Query: Codable {
    let q: String
    let state: [String]
    let facets: Facet?
    let sort: String
}

struct Facet: Codable {
    let name: String?
    let slug: String?
    let count_truncated: Bool?
    let children: [Child]?
}

struct Paging: Codable {
    let total_count: Int
    let total_count_truncated: Bool
    let total_pages: Int
    let page_size: Int
    let page: Int
    let has_next_page: Bool
}

struct Child: Codable {
    let id: Int
    let name: String
    let slug: String
    let display: String?
    let full_name: String?
    let url: String?
    let icon_url: String?
    let pinned_image_url: String?
    let count: Int?
    let count_truncated: Bool
    let has_children: Bool?
}
