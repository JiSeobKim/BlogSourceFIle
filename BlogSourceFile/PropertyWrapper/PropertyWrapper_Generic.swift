//
//  PropertyWrapper_High.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/27.
//

import Foundation

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

protocol DefaultWrapperAvailable {
    associatedtype ValueType: Decodable
    static var defaultValue: ValueType { get }
}

protocol DefaultWrapperStringConverterAvailable {
    static var defaultValue: Bool { get }
}

protocol JsonStringWrapperAvailable {
    static var defaultString: String { get }
}



enum DefaultWrapper {
    
    @propertyWrapper
    struct Wrapper<T: DefaultWrapperAvailable> {
        typealias ValueType = T.ValueType
        var wrappedValue = T.defaultValue
    }
    @propertyWrapper
    struct StringBoolConverter<T: DefaultWrapperStringConverterAvailable> {
        var wrappedValue = T.defaultValue
    }
    
    

    
    
    enum TypeCase {
        enum True: DefaultWrapperAvailable {
            static var defaultValue: Bool { true }
        }
        
        enum False: DefaultWrapperAvailable {
            static var defaultValue: Bool { false }
        }
        
        enum Zero<T: Decodable>: DefaultWrapperAvailable where T: Numeric {
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

extension DefaultWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(ValueType.self)
    }
}

extension DefaultWrapper.StringBoolConverter: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringBool = try? container.decode(String.self)
        let result = stringBool == "Y"
        wrappedValue = result
    }
}

extension DefaultWrapper {
    typealias DefaultTrue = Wrapper<DefaultWrapper.TypeCase.True>
    typealias DefaultFalse = Wrapper<DefaultWrapper.TypeCase.False>
    typealias DefaultZeroDouble = Wrapper<DefaultWrapper.TypeCase.Zero<Double>>
    typealias DefaultZeroInt = Wrapper<DefaultWrapper.TypeCase.Zero<Int>>
    typealias DefaultStringTrue = StringBoolConverter<DefaultWrapper.TypeCase.StringTrue>
    typealias DefaultStringFalse = StringBoolConverter<DefaultWrapper.TypeCase.StringFalse>
}

extension KeyedDecodingContainer {
    func decode<T: DefaultWrapperAvailable>(_ type: DefaultWrapper.Wrapper<T>.Type, forKey key: Key) throws -> DefaultWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: DefaultWrapperStringConverterAvailable>(_ type: DefaultWrapper.StringBoolConverter<T>.Type, forKey key: Key) throws -> DefaultWrapper.StringBoolConverter<T> {
        let value = try decodeIfPresent(type, forKey: key)
        let result = value ?? .init()
            
            return result
    }
    
    
}


// MARK: - Test
class PropertyWrapperGeneric: Decodable {
    @DefaultWrapper.DefaultTrue var isHiddenTrue
    @DefaultWrapper.DefaultFalse var isHiddenFalse
    @DefaultWrapper.DefaultZeroDouble var doubleValue: Double
    @DefaultWrapper.DefaultZeroInt var intValue: Int
    @DefaultWrapper.DefaultStringTrue var isStringTrue:Bool
    @DefaultWrapper.DefaultStringFalse var isStringFalse
    
    
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
