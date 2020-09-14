//
//  ItemCollectionViewCellTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class ItemCollectionViewCellTests: XCTestCase {
    var sut = Bundle.main.loadNibNamed("ItemCollectionViewCell", owner: nil, options: nil)?.first { nibView -> Bool in
        nibView is UIView
    } as? ItemCollectionViewCell

    func testAwakeFromNib() {
        sut?.awakeFromNib()

        XCTAssertNotNil(sut?.nameLabel)
        XCTAssertNotNil(sut?.priceLabel)
        XCTAssertNotNil(sut?.sellerLabel)
        XCTAssertNotNil(sut?.imageView)

        XCTAssertEqual(sut?.nameLabel.font, UIFont.largeBoldFont)
        XCTAssertEqual(sut?.priceLabel.font, UIFont.largeBoldFont)
        XCTAssertEqual(sut?.sellerLabel.font, UIFont.smallFont)
    }

    func testConfigure() {
        sut?.configure(title: "nike bag", price: "$20", seller: "kevin", imageURL: "")

        XCTAssertEqual(sut?.nameLabel.text, "nike bag")
        XCTAssertEqual(sut?.priceLabel.text, "$20")
        XCTAssertEqual(sut?.sellerLabel.text, "kevin")
        XCTAssertNil(sut?.imageView.image)
    }
}
