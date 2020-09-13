//
//  MetaModelTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class MetaModelTests: XCTestCase {
    func testValidJSON() {
        if let path = Bundle(for: type(of: self)).path(forResource: "validMetaResponse", ofType: "json") {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let metaModel = try decoder.decode(Meta.self, from: data)
                XCTAssertEqual(metaModel.paging.page, 1)
                XCTAssertTrue(metaModel.paging.has_next_page)
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
                XCTAssertThrowsError(try decoder.decode(Meta.self, from: data))
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
                _ = try decoder.decode(Meta.self, from: data)
                XCTFail("Incorrectly parsed invalid JSON")
            } catch {
                return
            }
        } else {
            XCTFail("Failed to find fixture")
        }
    }
}
