//
//  Seller.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/11/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

struct Seller: Codable {
    let id: Int
    let username: String
    let avatar_url: String?
    let following: String?
    let emblems: [String]
    let badges: [Badge]
}

struct Badge: Codable {
    let slug: String
    let name: String
}
