//
//  CategoryViewModelTest.swift
//  ShopyTests
//
//  Created by mohamed youssef on 6/17/21.
//  Copyright © 2021 mohamed youssef. All rights reserved.
//

import XCTest
@testable import Shopy
class CategoryViewModelTest: XCTestCase {

    var categoryViewModel:CategoryViewModel!
    var api:RemoteDataSource!
    var mockCategory: MockCategory!
    override func setUpWithError() throws {
        categoryViewModel = CategoryViewModel()
        api = RemoteDataSource()
        mockCategory = MockCategory(shouldReturnError: false)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        categoryViewModel = nil
        api = nil
        mockCategory = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMockCategory() {
        mockCategory.getDetailedProducts { (response) in
            switch response{
            case .success(let pro):
                XCTAssertEqual(pro!.products.count, 1)
            case .failure(_):
                 XCTFail()
            }
        }

    }
    
    
    func testCatviewodel(){
        let expObj = expectation(description: "wait for response")

        categoryViewModel.productsObservable.asObservable().subscribe{ productElement in
                  expObj.fulfill()

                   XCTAssertEqual( productElement.element!.count, 17)
               }
        
        categoryViewModel.fetchData()
        categoryViewModel.fetchFilterdProducts(mainCategoryElement:"Men",subCategoryElement:"Shoes")
        waitForExpectations(timeout: 5)

       
    }
    
    func testfetchProducts(){
        let expObj = expectation(description: "wait for response")
//        categoryViewModel.fetchFilterdProducts(mainCategoryElement:"Men",subCategoryElement:"Shoes")
//        let mainCategoryElement = "Men"
//        let subCategoryElement = "T-Shits"
        let mainCategoryElement = "Kids"
           let subCategoryElement = "Shoes"
           api.getCategoryProducts(categoryType: mainCategoryElement) {(response) in
             var ProductElements:[ProductElement]?
                 switch response{
                 case .success(let category):
                  
                    ProductElements = category?.products
                     let filteredProducts = ProductElements?.filter({(categor) -> Bool in
                         categor.productType.capitalized == subCategoryElement.capitalized
                     })
                     ProductElements = filteredProducts
                      expObj.fulfill()
                    XCTAssertEqual(filteredProducts!.count , 3)
                 case .failure(_):
                   XCTFail()
                 }
             }
            waitForExpectations(timeout: 5)
        
        
    }
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
