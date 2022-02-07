//
//  BlogSourceFileTests.swift
//  BlogSourceFileTests
//
//  Created by 김지섭 on 2021/05/30.
//

import XCTest
@testable import BlogSourceFile

class MockTests: XCTestCase {

    private var sut: TestDouble.Company!
    private var printerMock: TestDouble.PrinterMock!
    
    override func setUp() {
        printerMock = TestDouble.PrinterMock()
        sut = TestDouble.Company(printer: printerMock)
    }
    func test_call_network() {
        // given
        // when
        sut.submit(complete: {})
        
        // then
        XCTAssertEqual(printerMock.networkCallCount, 1)
    }
}


class SPYTests: XCTestCase {

    private var sut: TestDouble.Company!
    private var printerSPY: TestDouble.PrinterSPY!
    
    override func setUp() {
        printerSPY = TestDouble.PrinterSPY()
        sut = TestDouble.Company(printer: printerSPY)
    }
    func test_call_network() {
        // given
        let exp = expectation(description: "exp")
        
        // when
        sut.submit(complete: {
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 2)
        
        // then
        XCTAssertEqual(sut.printedText, "안녕 SPY?")
        XCTAssertEqual(printerSPY.networkCallCount, 1)
    }
}

class StubTests: XCTestCase {

    private var sut: TestDouble.Company!
    private var printerStub: TestDouble.PrinterStub!
    
    override func setUp() {
        printerStub = TestDouble.PrinterStub()
        sut = TestDouble.Company(printer: printerStub)
    }
    func test_call_network() {
        // given
        let exp = expectation(description: "exp")
        
        // when
        sut.submit(complete: {
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 2)
        
        // then
        XCTAssertEqual(sut.printedText, "안녕 Stub?")
    }
}
