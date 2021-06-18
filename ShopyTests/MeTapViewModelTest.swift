//
//  MeTapViewModel.swift
//  ShopyTests
//
//  Created by Amin on 17/06/2021.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import XCTest
import RxSwift

@testable import Shopy
class MeTapViewModelTest: XCTestCase {

    var meTapViewModel:MeTapViewModel!
    var bag :DisposeBag!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        meTapViewModel = MeTapViewModel()
        bag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        meTapViewModel = nil
        bag = nil
    }

    func testGetUserName(){
        XCTAssertEqual(meTapViewModel.getUserName(), "amin")
    }
    
    func testIsLightTheme()  {
        XCTAssert(meTapViewModel.isLightTheme())
    }
    
    func testFetchOrders() {
        let expt = expectation(description: "wait")
        
        meTapViewModel.ordersObservable?.asObservable().subscribe { orders in
            expt.fulfill()
        }.disposed(by: bag)
        
        meTapViewModel.fetchOrders()
        
        waitForExpectations(timeout: 5)
        
    }
    
    
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
