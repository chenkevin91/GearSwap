//
//  ImageHelperTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class ImageHelperTests: XCTestCase {
    var sut: ImageHelper!
    let mockSession = MockURLSession()

    override func setUp() {
        super.setUp()
        sut = ImageHelper(session: mockSession)
    }

    override func tearDown() {
        mockSession.nextData = nil
        super.tearDown()
    }

    func testGetImage() {
        let url = URL(string: "https://mockurl")
        mockSession.nextData = UIImage.checkmark.pngData()

        var testImageURL: URL?

        XCTAssertNil(testImageURL)

        sut.getImage(from: url!) { imageResult in
            testImageURL = imageResult?.url
        }

        XCTAssertEqual(testImageURL?.absoluteString, "https://mockurl")
    }

    func testBadData() {
        let url = URL(string: "https://mockurl")
        mockSession.nextData = nil

        sut.getImage(from: url!) { imageResult in
            XCTAssertNil(imageResult)
        }
    }
}
