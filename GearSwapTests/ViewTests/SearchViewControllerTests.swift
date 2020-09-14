//
//  SearchViewControllerTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class SearchViewControllerTests: XCTestCase {
    var sut: SearchViewController!

    override func setUp() {
        super.setUp()
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? SearchViewController
        _ = sut.view
    }

    func testItemsIsPopulated() {
        let mockSession = MockURLSession()
        let mockPresenter = MockSearchPresenter(session: mockSession)
        let path = Bundle(for: type(of: self)).path(forResource: "validSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        sut.presenter = mockPresenter
        sut.viewDidLoad()

        XCTAssertTrue(sut.items.isEmpty)
        sut.refreshSearch()
        XCTAssertFalse(sut.items.isEmpty)
    }

    func testUpdateStatusPopsAlert() {
        let mockSession = MockURLSession()
        let mockPresenter = MockSearchPresenter(session: mockSession)
        let path = Bundle(for: type(of: self)).path(forResource: "invalidResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        sut.presenter = mockPresenter
        sut.viewDidLoad()

        XCTAssertTrue(sut.items.isEmpty)
        sut.refreshSearch()
        XCTAssertTrue(sut.items.isEmpty)
    }

    func testSearchBar() {
        let mockSession = MockURLSession()
        let mockPresenter = MockSearchPresenter(session: mockSession)
        let path = Bundle(for: type(of: self)).path(forResource: "validSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        sut.presenter = mockPresenter
        sut.viewDidLoad()

        sut.searchBar.text = "nike bag"

        XCTAssertTrue(sut.items.isEmpty)
        sut.searchBarSearchButtonClicked(sut.searchBar)
        XCTAssertFalse(sut.items.isEmpty)
    }

    func testCollectionView() {
        let mockSession = MockURLSession()
        let mockPresenter = MockSearchPresenter(session: mockSession)
        let path = Bundle(for: type(of: self)).path(forResource: "validSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        sut.presenter = mockPresenter
        sut.viewDidLoad()
        sut.searchBar.text = "nike bag"
        sut.searchBarSearchButtonClicked(sut.searchBar)
        sut.viewDidLoad()

        XCTAssertEqual(sut.collectionView(sut.collectionView, numberOfItemsInSection: 0), sut.items.count)

        let expectedCell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as! ItemCollectionViewCell

        XCTAssertNotNil(expectedCell)
        XCTAssertEqual(expectedCell.nameLabel.text, "Nike Bag")
        XCTAssertEqual(expectedCell.sellerLabel.text, "amabill2001")
        XCTAssertEqual(expectedCell.priceLabel.text, "$180")
    }

    func testRefreshCalledWhenNearBottomOfCollection() {
        let mockSession = MockURLSession()
        let mockPresenter = MockSearchPresenter(session: mockSession)
        let path = Bundle(for: type(of: self)).path(forResource: "validSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        sut.presenter = mockPresenter
        sut.viewDidLoad()
        sut.searchBar.text = "nike bag"
        sut.searchBarSearchButtonClicked(sut.searchBar)
        sut.viewDidLoad()

        XCTAssertEqual(sut.collectionView(sut.collectionView, numberOfItemsInSection: 0), sut.items.count)
        XCTAssertEqual(sut.items.count, 20)

        sut.collectionView(sut.collectionView, willDisplay: ItemCollectionViewCell(), forItemAt: IndexPath(row: 15, section: 0))
        sut.viewDidLoad()

        XCTAssertEqual(sut.collectionView(sut.collectionView, numberOfItemsInSection: 0), sut.items.count)
        XCTAssertEqual(sut.items.count, 40)
    }
}

extension SearchViewControllerTests {
    class MockSearchPresenter: SearchPresenter {
        let session = MockURLSession()
    }
}

