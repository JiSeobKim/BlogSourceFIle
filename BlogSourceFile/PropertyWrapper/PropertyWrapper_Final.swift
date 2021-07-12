//
//  PropertyWrapper_Final.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/07/11.
//

import Foundation
import UIKit

protocol JSONDefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

protocol JSONStringConverterAvailable {
    static var defaultValue: Bool { get }
}

enum JSONDefaultWrapper {
    typealias EmptyString = Wrapper<JSONDefaultWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSONDefaultWrapper.TypeCase.True>
    typealias False = Wrapper<JSONDefaultWrapper.TypeCase.False>
    typealias IntZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Int>>
    typealias DoubleZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Double>>
    typealias FloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Float>>
    typealias CGFloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<CGFloat>>
    typealias StringFalse = StringConverterWrapper<JSONDefaultWrapper.TypeCase.StringFalse>
    typealias StringTrue = StringConverterWrapper<JSONDefaultWrapper.TypeCase.StringTrue>
    typealias EmptyList<T: Decodable & ExpressibleByArrayLiteral> = Wrapper<JSONDefaultWrapper.TypeCase.List<T>>
    
    // Property Wrapper - Optional Type to Type
    @propertyWrapper
    struct Wrapper<T: JSONDefaultWrapperAvailable> {
        typealias ValueType = T.ValueType

        var wrappedValue: ValueType

        init() {
        wrappedValue = T.defaultValue
        }
    }
    
    // Property Wrapper - Optional String To Bool
    @propertyWrapper
    struct StringConverterWrapper<T: JSONStringConverterAvailable> {
        var wrappedValue: Bool = T.defaultValue
    }
    
    // Property Wrapper - Optional Timestamp to Optinoal Date
    @propertyWrapper
    struct TimestampToOptionalDate {
        var wrappedValue: Date?
    }
    
    @propertyWrapper
    struct TrueByStringToBool {
        var wrappedValue: Bool = true
    }
    
    @propertyWrapper
    struct FalseByStringToBool {
        var wrappedValue: Bool = false
    }

    enum TypeCase {
        // Type Enums
        enum True: JSONDefaultWrapperAvailable {
            // 기본값 - true
            static var defaultValue: Bool { true }
        }

        enum False: JSONDefaultWrapperAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }

        enum EmptyString: JSONDefaultWrapperAvailable {
            // 기본값 - ""
            static var defaultValue: String { "" }
        }
        
        enum Zero<T: Decodable>: JSONDefaultWrapperAvailable where T: Numeric {
            // 기본값 - 0
            static var defaultValue: T { 0 }
        }
        
        enum StringFalse: JSONStringConverterAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }
        
        enum StringTrue: JSONStringConverterAvailable {
            // 기본값 - false
            static var defaultValue: Bool { true }
        }
        
        enum List<T: Decodable & ExpressibleByArrayLiteral>: JSONDefaultWrapperAvailable {
            // 기본값 - []
            static var defaultValue: T { [] }
        }
    }
}

extension JSONDefaultWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension JSONDefaultWrapper.StringConverterWrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(String.self)) == "Y"
    }
}

extension JSONDefaultWrapper.TimestampToOptionalDate: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timestamp = try container.decode(Double.self)
        let date = Date.init(timeIntervalSince1970: timestamp)
        self.wrappedValue = date
    }
}

extension KeyedDecodingContainer {
    func decode<T: JSONDefaultWrapperAvailable>(_ type: JSONDefaultWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: JSONStringConverterAvailable>(_ type: JSONDefaultWrapper.StringConverterWrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.StringConverterWrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: JSONDefaultWrapper.TimestampToOptionalDate.Type, forKey key: Key) throws -> JSONDefaultWrapper.TimestampToOptionalDate {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

class Posting: Decodable {
    // Property Wrapper를 이용한 프로퍼티
    @JSONDefaultWrapper.EmptyString var stringValue: String
    @JSONDefaultWrapper.True var trueValue: Bool
    @JSONDefaultWrapper.False var falseValue: Bool
    @JSONDefaultWrapper.IntZero var intValue: Int
    @JSONDefaultWrapper.DoubleZero var doubleValue: Double
    @JSONDefaultWrapper.FloatZero var floatValue: Float
    @JSONDefaultWrapper.CGFloatZero var cGFloatValue: CGFloat
    @JSONDefaultWrapper.StringFalse var stringFalseValue: Bool
    @JSONDefaultWrapper.StringTrue var stringTrueValue: Bool
    @JSONDefaultWrapper.TimestampToOptionalDate var dateValue: Date?
    
    static func test() {
        // 전혀 상관없는 JSON 형태의 데이터
        let data = """
            {
                "test": 3,
                "dateValue" : 1626012942
            }
            """.data(using: .utf8)!
        
        // Decodable을 이용한 객체 생성
        let object = try! JSONDecoder().decode(Posting.self, from: data)
        
        // 빈값인지 확인
        print("""
            stringValue는 빈 값인가? \(object.stringValue == "")
            trueValue는? \(object.trueValue)
            falseValue는? \(object.falseValue)
            intValue는? \(object.intValue)
            doubleValue는? \(object.doubleValue)
            floatValue는? \(object.floatValue)
            cGFloatValue는? \(object.cGFloatValue)
            stringFalseValue는? \(object.stringFalseValue)
            stringTrueValue는? \(object.stringTrueValue)
            dateValue는? \(object.dateValue)
            """)
    }
}

class Posting2: Decodable {
    @JSONDefaultWrapper.StringFalse var stringFalseValue: Bool
    @JSONDefaultWrapper.StringTrue var stringTrueValue: Bool
    @JSONDefaultWrapper.TimestampToOptionalDate var dateValue: Date?
    @JSONDefaultWrapper.EmptyList var listValue: [Posting3]
    
    static func test() {
        // 전혀 상관없는 JSON 형태의 데이터
        let data = """
            {
                "stringFalseValue": "Y",
                "stringTrueValue": "N",
                "dateValue" : 1626012942,
                "listValue" : [
                    {"isTest" : "Hi"},
                    {"isTest" : "Hi2"},
                ]
            }
            """.data(using: .utf8)!
        
        // Decodable을 이용한 객체 생성
        let object = try! JSONDecoder().decode(Posting2.self, from: data)
        
        // 다른 타입으로 변환 - 키 없을 시 기본 값 사용
        print("""
            stringFalseValue는? \(object.stringFalseValue)
            stringTrueValue는? \(object.stringTrueValue)
            """)
        
        
        // 다른 타입으로 변환 - 옵셔널
        if let dateValue = object.dateValue {
            print("dateValue는? \(dateValue)")
        } else {
            print("dateValue는? nil이다")
        }
        
        // 리스트 처리
        print("listValue는? \(object.listValue.count)개")
    }
}


class Posting3: Decodable {
    var isTest: String?
}
