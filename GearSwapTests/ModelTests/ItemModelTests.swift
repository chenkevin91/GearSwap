//
//  ItemModelTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class ItemModelTests: XCTestCase {
    func testValidJSON() {
        if let path = Bundle(for: type(of: self)).path(forResource: "validItemResponse", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let itemModel = try decoder.decode(Item.self, from: data)
                XCTAssertEqual(itemModel.id, 929175)
                XCTAssertEqual(itemModel.name, "Nike Lunar Control Vapor 2 Men's Golf Shoes Black/White 899633-002  Size 11.5")
                XCTAssertEqual(itemModel.price, 82.99)
                XCTAssertEqual(itemModel.seller.username, "saul06can")
                XCTAssertNotNil(itemModel.primary_image)
            } catch {
                XCTFail("Failed to parse")
            }
        } else {
            XCTFail("Failed to find fixture")
        }
    }

    func testEmptyJSON() {
        if let path = Bundle(for: type(of: self)).path(forResource: "emptyResponse", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                XCTAssertThrowsError(try decoder.decode(Item.self, from: data))
            } catch {
                XCTFail("Failed to throw error")
            }
        } else {
            XCTFail("Failed to find fixture")
        }
    }

    func testInvalidJSON() {
        if let path = Bundle(for: type(of: self)).path(forResource: "invalidResponse", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                _ = try decoder.decode(Item.self, from: data)
                XCTFail("Incorrectly parsed invalid JSON")
            } catch {
                return
            }
        } else {
            XCTFail("Failed to find fixture")
        }
    }
}
