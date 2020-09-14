//
//  SearchPresenterTests.swift
//  GearSwapTests
//
//  Created by Kevin Chen on 9/13/20.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import XCTest
@testable import GearSwap

class SearchPresenterTests: XCTestCase {
    var sut: SearchPresenter!
    let mockSession = MockURLSession()

    override func setUp() {
        super.setUp()
        sut = SearchPresenter(session: mockSession)
    }

    override func tearDown() {
        mockSession.nextData = nil
        super.tearDown()
    }

    func testSuccessfulSearch() {
        let spyView = SpySearchView()
        sut.attach(spyView)

        let path = Bundle(for: type(of: self)).path(forResource: "validSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        XCTAssertFalse(spyView.updateItemViewModelWasCalled)
        
        sut.getSearchResults("nike bag", fromRefreshControl: false)

        XCTAssertTrue(spyView.updateItemViewModelWasCalled)
    }

    func testEmptySearch() {
        let spyView = SpySearchView()
        sut.attach(spyView)

        let path = Bundle(for: type(of: self)).path(forResource: "emptySearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        XCTAssertFalse(spyView.updateStatusWasCalled)
        XCTAssertNil(spyView.givenStatus)

        sut.getSearchResults("adfdsf", fromRefreshControl: false)

        XCTAssertTrue(spyView.updateStatusWasCalled)
        XCTAssertEqual(spyView.givenStatus, "No results matching your search. Please try again.")
    }

    func testBadSearch() {
        let spyView = SpySearchView()
        sut.attach(spyView)

        let path = Bundle(for: type(of: self)).path(forResource: "invalidResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        XCTAssertFalse(spyView.updateStatusWasCalled)
        XCTAssertNil(spyView.givenStatus)

        sut.getSearchResults(" ", fromRefreshControl: false)

        XCTAssertTrue(spyView.updateStatusWasCalled)
        XCTAssertEqual(spyView.givenStatus, "Sorry, something went wrong. Please try again.")
    }

    func testBadResponseData() {
        let spyView = SpySearchView()
        sut.attach(spyView)
        mockSession.nextData = nil

        XCTAssertFalse(spyView.updateStatusWasCalled)
        XCTAssertNil(spyView.givenStatus)

        sut.getSearchResults(" ", fromRefreshControl: false)

        XCTAssertTrue(spyView.updateStatusWasCalled)
        XCTAssertEqual(spyView.givenStatus, "Sorry, something went wrong. Please try again.")
    }

    func testSearchFromRefreshControl() {
        let spyView = SpySearchView()
        sut.attach(spyView)

        let path = Bundle(for: type(of: self)).path(forResource: "validSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        sut.getSearchResults("nike bag", fromRefreshControl: false)

        XCTAssertEqual(mockSession.lastURL?.absoluteString, "https://api.staging.sidelineswap.com/v1/facet_items?q=nike%20bag")

        sut.getSearchResults(fromRefreshControl: true)

        XCTAssertEqual(mockSession.lastURL?.absoluteString, "https://api.staging.sidelineswap.com/v1/facet_items?q=nike%20bag")
    }

    func testSearchNextPage() {
        let spyView = SpySearchView()
        sut.attach(spyView)

        let path = Bundle(for: type(of: self)).path(forResource: "validSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        sut.getSearchResults("nike bag", fromRefreshControl: false)

        XCTAssertEqual(mockSession.lastURL?.query, "q=nike%20bag")

        sut.getSearchResults()

        XCTAssertEqual(mockSession.lastURL?.query, "q=nike%20bag&page=2")
    }

    func testNoMorePages() {
        let spyView = SpySearchView()
        sut.attach(spyView)

        let path = Bundle(for: type(of: self)).path(forResource: "finalPageSearchResponse", ofType: "json")!
        mockSession.nextData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

        XCTAssertEqual(spyView.updateCount, 0)

        sut.getSearchResults("nike bag", fromRefreshControl: false)

        XCTAssertEqual(spyView.updateCount, 1)

        sut.getSearchResults()

        XCTAssertEqual(spyView.updateCount, 1)
    }
}

extension SearchPresenterTests {
    class SpySearchView: SearchViewProtocol {
        var updateCount = 0

        var updateItemViewModelWasCalled = false
        func update(itemViewModel: [ItemViewModel]) {
            updateItemViewModelWasCalled = true
            updateCount += 1
        }

        var updateStatusWasCalled = false
        var givenStatus: String?
        func update(status: String) {
            updateStatusWasCalled = true
            givenStatus = status
            updateCount += 1
        }
    }
}
