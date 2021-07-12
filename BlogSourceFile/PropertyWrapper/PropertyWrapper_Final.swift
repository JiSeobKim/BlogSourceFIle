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
