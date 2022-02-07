//
//  TestDouble.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2022/02/07.
//

import Foundation
import UIKit

protocol Calculator {
    func sum(x: Int, y: Int) -> Int
}

protocol Printer {
    func network(handler: @escaping (String) -> Void)
}

class TestDouble {
    class CalculatorImp: Calculator {
        let b: Some
        let c: Some2
        
        init(b: Some, c: Some2) {
            self.b = b
            self.c = c
        }
        
        func sum(x: Int, y: Int) -> Int {
            b.callMethod()
            b.callMethod2()
            b.callMethod3()
            
            if x > 0 {
                c.callLogMethod()
            }
            let result = x + y
            return result
        }
    }
    
    
    class CalculatorFake: Calculator {
        func sum(x: Int, y: Int) -> Int {
            let result = x + y
            return result
        }
    }
    
    class Some {
        func callMethod() {
            
        }
        func callMethod2() {
            
        }
        func callMethod3() {
            
        }
    }
    
    class Some2 {
        func callLogMethod() {
            
        }
    }
    
    class PrinterImp: Printer {
        func network(handler: @escaping (String) -> Void) {
            let url = URL(string: "naver.com")!
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                // 어떤 액션들 블라 블라...
                guard
                    let data = data,
                    let result = String(data: data, encoding: .utf8)
                else {
                    return
                }
                // handler 사용
                handler(result)
            }
            
            task.resume()
        }
    }
    
    class PrinterStub: Printer {
        
        var handlerValue = "안녕 Stub?"
        
        func network(handler: @escaping (String) -> Void) {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                handler(self.handlerValue)
            }
        }
    }
    
    class PrinterMock: Printer {
        
        var networkCallCount = 0
        
        func network(handler: @escaping (String) -> Void) {
            networkCallCount += 1
        }
    }
    
    class PrinterSPY: Printer {
        
        var handlerValue = "안녕 SPY?"
        
        var networkCallCount = 0
        func network(handler: @escaping (String) -> Void) {
            networkCallCount += 1

            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                handler(self.handlerValue)
            }
        }
    }
    
    class Company {
        var printer: Printer
        var printedText: String?
        
        init(printer: Printer) {
            self.printer = printer
        }
        
        func submit(complete: @escaping ()->Void) {
            printer.network(handler: { value in
                self.printedText = value
                complete()
            })
        }
    }
}

