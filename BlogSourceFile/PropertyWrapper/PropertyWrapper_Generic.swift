//
//  PropertyWrapper_High.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/27.
//

import Foundation
import UIKit

// MARK: - High Level
protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

enum DecodableDefault{}

extension DecodableDefault {
    @propertyWrapper
    struct Wrapper<T: DecodableDefaultSource>  {
        typealias Value = T.Value
        var wrappedValue = T.defaultValue
    }
}

extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral
    
    enum SourceType {
        enum True: Source {
            static var defaultValue: Bool { true }
        }
        
        enum False: Source {
            static var defaultValue: Bool { false }
        }
        
        enum EmptyString: Source {
            static var defaultValue: String { "" }
        }
        
        enum EmptyList<T: List>: Source {
            static var defaultValue: T { [] }
        }
        
        enum EmptyMap<T: Map>: Source {
            static var defaultValue: T { [:]}
        }
    }
}

extension DecodableDefault {
    typealias True = Wrapper<SourceType.True>
    typealias False = Wrapper<SourceType.False>
    typealias EmptyString = Wrapper<SourceType.EmptyString>
    typealias EmptyList<T: List> = Wrapper<SourceType.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<SourceType.EmptyMap<T>>
}

extension DecodableDefault.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type, forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}


// MARK: - Test

protocol JSONDefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

protocol DefaultWrapperStringConverterAvailable {
    static var defaultValue: Bool { get }
}

protocol JsonStringWrapperAvailable {
    static var defaultString: String { get }
}



enum JSONDefaultWrapper2 {
    
    @propertyWrapper
    struct Wrapper<T: JSONDefaultWrapperAvailable> {
        typealias ValueType = T.ValueType
        var wrappedValue: ValueType
        init() {
            wrappedValue = T.defaultValue
        }
    }
    @propertyWrapper
    struct StringBoolConverter<T: DefaultWrapperStringConverterAvailable> {
        var wrappedValue = T.defaultValue
    }
    
    
    enum TypeCase {
        enum True: JSONDefaultWrapperAvailable {
            static var defaultValue: Bool { true }
        }
        
        enum False: JSONDefaultWrapperAvailable {
            static var defaultValue: Bool { false }
        }
        
        enum EmptyString: JSONDefaultWrapperAvailable {
            static var defaultValue: String { "" }
        }
        
        enum Zero<T: Decodable>: JSONDefaultWrapperAvailable where T: Numeric {
            static var defaultValue: T { 0 }
        }
        
        enum StringTrue: DefaultWrapperStringConverterAvailable {
            static var defaultValue: Bool { true }
        }
        
        enum StringFalse: DefaultWrapperStringConverterAvailable {
            static var defaultValue: Bool { false }
        }
    }
}

extension JSONDefaultWrapper2.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(ValueType.self)
        
    
    }
    
    
}

extension JSONDefaultWrapper2.StringBoolConverter: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringBool = try? container.decode(String.self)
        let result = stringBool == "Y"
        wrappedValue = result
    }
}

extension JSONDefaultWrapper2 {
    typealias DefaultTrue = Wrapper<JSONDefaultWrapper2.TypeCase.True>
    typealias DefaultFalse = Wrapper<JSONDefaultWrapper2.TypeCase.False>
    typealias DefaultZeroDouble = Wrapper<JSONDefaultWrapper2.TypeCase.Zero<Double>>
    typealias DefaultZeroInt = Wrapper<JSONDefaultWrapper2.TypeCase.Zero<Int>>
    typealias DefaultZeroCGFloat = Wrapper<JSONDefaultWrapper2.TypeCase.Zero<CGFloat>>
    typealias DefaultStringTrue = StringBoolConverter<JSONDefaultWrapper2.TypeCase.StringTrue>
    typealias DefaultStringFalse = StringBoolConverter<JSONDefaultWrapper2.TypeCase.StringFalse>
}

extension KeyedDecodingContainer {
    func decode<T: JSONDefaultWrapperAvailable>(_ type: JSONDefaultWrapper2.Wrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper2.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: DefaultWrapperStringConverterAvailable>(_ type: JSONDefaultWrapper2.StringBoolConverter<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper2.StringBoolConverter<T> {
        let value = try decodeIfPresent(type, forKey: key)
        let result = value ?? .init()
            
            return result
    }
    
    
}


// MARK: - Test
class PropertyWrapperGeneric: Decodable {
    @JSONDefaultWrapper2.DefaultTrue var isHiddenTrue
    @JSONDefaultWrapper2.DefaultFalse var isHiddenFalse
    @JSONDefaultWrapper2.DefaultZeroDouble var doubleValue: Double
    @JSONDefaultWrapper2.DefaultZeroInt var intValue: Int
    @JSONDefaultWrapper2.DefaultStringTrue var isStringTrue:Bool
    @JSONDefaultWrapper2.DefaultStringFalse var isStringFalse
    
    
    static func test() {
        let json = """
            {
                "isHiddenTrue" : false,
                "isStringTrue" : "N"
            }
            """.data(using: .utf8)!
        
        
        do {
            let object = try JSONDecoder().decode(PropertyWrapperGeneric.self, from: json)
            print("""
                \(object.isHiddenTrue)
                \(object.isHiddenFalse)
                \(object.doubleValue)
                \(object.intValue)
                \(object.isStringTrue)
                \(object.isStringFalse)
                """)
        } catch {
            
        }
    }
}



// MARK: - For Posting


class WrapperPosting {
    @propertyWrapper
    struct JsonStringWrapper<T: JsonStringWrapperAvailable> {
        var wrappedValue = T.defaultString
    }

    enum DefaultEmptyString: JsonStringWrapperAvailable {
        static var defaultString: String { "" }
    }
    @JsonStringWrapper<DefaultEmptyString> var a
    
    
//    func test() {
//        let a: DefaultEmptyString
//    }
}


class WrapperPosting1: Decodable {
    @propertyWrapper
    struct JsonStringWrapper: Decodable {
        let wrappedValue: String
        
        init() {
            wrappedValue = ""
        }
    }
    
    @JsonStringWrapper var usrNm: String
    @JsonStringWrapper var usrAddress: String
    
    static func run() {
        let jsonData = """
            {
                "usrNm" : "KJS"
            }
            """.data(using: .utf8)!
        
        let data = try! JSONDecoder().decode(WrapperPosting1.self, from: jsonData)
        print("data.usrNm - \(data.usrNm)")
        print("data.usrAddress - \(data.usrAddress)")
    }
    
}


extension WrapperPosting1.JsonStringWrapper {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(String.self)
    }
}


extension KeyedDecodingContainer {
    func decode(_ type: WrapperPosting1.JsonStringWrapper.Type, forKey key: Key) throws -> WrapperPosting1.JsonStringWrapper {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

// MARK: - For Posting 3
enum JSONDefaultWrapper {
    typealias EmptyString = Wrapper<JSONDefaultWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSONDefaultWrapper.TypeCase.True>
    typealias False = Wrapper<JSONDefaultWrapper.TypeCase.False>
    typealias IntZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Int>>
    typealias DoubleZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Double>>
    typealias FloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Float>>
    typealias CGFloatZero = Wrapper<JSONDefaultWrapper.TypeCase.Zero<CGFloat>>
    
    // Property Wrapper
    @propertyWrapper
    struct Wrapper<T: JSONDefaultWrapperAvailable> {
        typealias ValueType = T.ValueType

        var wrappedValue: ValueType

        init() {
        wrappedValue = T.defaultValue
        }
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
    }
}

extension JSONDefaultWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension KeyedDecodingContainer {
    func decode<T: JSONDefaultWrapperAvailable>(_ type: JSONDefaultWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.Wrapper<T> {
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
    
    static func test() {
        // 전혀 상관없는 JSON 형태의 데이터
        let data = """
            {
                "test": 3,
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
            """)
    }
}
