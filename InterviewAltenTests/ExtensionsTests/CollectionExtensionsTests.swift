//
//  CollectionExtensionsTests.swift
//  InterviewAltenTests
//
//  Created by Paweł Sobaszek on 06/03/2023.
//

import XCTest
@testable import InterviewAlten

final class CollectionExtensionsTests: XCTestCase {
    
    func test_collectionEmpty_isNotEmpty_returnsFalse() {
        let actual = [].isNotEmpty
        let expected = false
        
        XCTAssertEqual(actual, expected)
    }
    
    func test_collectionThreeElements_isNotEmpty_returnsTrue() {
        let actual = ["a", "b", "c"].isNotEmpty
        let expected = true
        
        XCTAssertEqual(actual, expected)
    }
}
