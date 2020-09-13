//
//  ExtensionTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class ExtensionTests: XCTestCase {
    func testDoubleFormattedToCurrency() {
        let test1 = 0.0
        let test2 = 1.0
        let test3 = 2.5
        let test4 = 124.0

        let expected1 = "$0"
        let expected2 = "$1"
        let expected3 = "$2"
        let expected4 = "$124"

        XCTAssertEqual(test1.formattedToCurrency(), expected1)
        XCTAssertEqual(test2.formattedToCurrency(), expected2)
        XCTAssertEqual(test3.formattedToCurrency(), expected3)
        XCTAssertEqual(test4.formattedToCurrency(), expected4)
    }

    func testGrayBorder() {
        XCTAssertEqual(UIColor.grayBorder, UIColor(red: 0.898039, green: 0.898039, blue: 0.917647, alpha: 1))
    }

    func testFonts() {
        XCTAssertEqual(UIFont.largeBoldFont, UIFont.boldSystemFont(ofSize: 16))
        XCTAssertEqual(UIFont.smallFont, UIFont.systemFont(ofSize: 12))
    }
}
