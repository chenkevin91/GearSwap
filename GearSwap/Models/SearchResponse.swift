//
//  SearchResponse.swift
//  GearSwap
//
//  Created by Kevin Chen on 9/11/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let data: [Item]
    let meta: Meta
}
