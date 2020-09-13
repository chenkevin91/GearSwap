//
//  ImageModelTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class ImageModelTests: XCTestCase {
    func testValidJSON() {
        if let path = Bundle(for: type(of: self)).path(forResource: "validImageResponse", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let imageModel = try decoder.decode(Image.self, from: data)
                XCTAssertEqual(imageModel.id, 3332779)
                XCTAssertEqual(imageModel.thumb_url, "https://images.sidelineswap.com/production/003/332/779/b8c5a1f14acd87d8_thumb.jpeg")
                XCTAssertEqual(imageModel.small_url, "https://images.sidelineswap.com/production/003/332/779/b8c5a1f14acd87d8_small.jpeg")
                XCTAssertEqual(imageModel.large_url, "https://images.sidelineswap.com/production/003/332/779/b8c5a1f14acd87d8_original.jpeg")
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
                XCTAssertThrowsError(try decoder.decode(Image.self, from: data))
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
                _ = try decoder.decode(Image.self, from: data)
                XCTFail("Incorrectly parsed invalid JSON")
            } catch {
                return
            }
        } else {
            XCTFail("Failed to find fixture")
        }
    }
}
