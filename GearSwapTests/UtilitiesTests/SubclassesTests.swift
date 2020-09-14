//
//  SubclassesTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class SubclassesTests: XCTestCase {
    func testDownloadableImageView() {
        let downloadableImageView = DownloadableImageView()

        downloadableImageView.getImage(from: "https://images.sidelineswap.com/production/003/332/779/b8c5a1f14acd87d8_thumb.jpeg")

        XCTAssertEqual(downloadableImageView.lastUsedUrl?.absoluteString, "https://images.sidelineswap.com/production/003/332/779/b8c5a1f14acd87d8_thumb.jpeg")
    }

}
