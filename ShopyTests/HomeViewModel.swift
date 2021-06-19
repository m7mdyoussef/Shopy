//
//  HomeViewModel.swift
//  ShopyTests
//
//  Created by SOHA on 6/18/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
@testable import Shopy
class HomeViewModelTest: XCTestCase {
    var homeViewModel:HomeModelType?
    var api:RemoteDataSource!
    var bag :DisposeBag!
    override func setUpWithError() throws {
        homeViewModel = HomeViewModel()
        api = RemoteDataSource()
        bag = DisposeBag()
    }
    override func tearDownWithError() throws {
        homeViewModel = nil
        api = nil
    }
    
    func testGetAllProducts(){
        let expect = expectation(description: "load response")
        homeViewModel?.productsDataObservable?.asObservable().subscribe{(products) in
            expect.fulfill()
            XCTAssertEqual(products.element?.count, 20)
        }.disposed(by: bag)
        homeViewModel?.getAllProduct(id: "268359598278")
        waitForExpectations(timeout: 5)
}
    
    func testGetCollectionData(){
        let expect = expectation(description: "load response")
        homeViewModel?.collectionDataObservable?.asObservable().subscribe{(categories) in
            expect.fulfill()
            XCTAssertNotNil(categories.element)
        }.disposed(by: bag)
        homeViewModel?.getCollectionData()
        waitForExpectations(timeout: 5)
    }
    
    func testGetProductElement(){
        let expect = expectation(description: "load response")
        homeViewModel?.productElementObservable?.asObservable().subscribe{(element) in
            expect.fulfill()
            XCTAssertNotNil(element.element)
        }.disposed(by: bag)
        homeViewModel?.getProductElement(idProduct: "6687367266502")
        waitForExpectations(timeout: 5)
    }
    
    
}
