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



enum JSONDefaultWrapper {
    
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

extension JSONDefaultWrapper.Wrapper: Decodable {
    class AA {
        
    }
    struct BB {
        
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(ValueType.self)
        
        let aa = AA()
        let bb = BB()
    
    }
    
    
}

extension JSONDefaultWrapper.StringBoolConverter: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringBool = try? container.decode(String.self)
        let result = stringBool == "Y"
        wrappedValue = result
    }
}

extension JSONDefaultWrapper {
    typealias DefaultTrue = Wrapper<JSONDefaultWrapper.TypeCase.True>
    typealias DefaultFalse = Wrapper<JSONDefaultWrapper.TypeCase.False>
    typealias DefaultZeroDouble = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Double>>
    typealias DefaultZeroInt = Wrapper<JSONDefaultWrapper.TypeCase.Zero<Int>>
    typealias DefaultStringTrue = StringBoolConverter<JSONDefaultWrapper.TypeCase.StringTrue>
    typealias DefaultStringFalse = StringBoolConverter<JSONDefaultWrapper.TypeCase.StringFalse>
}

extension KeyedDecodingContainer {
    func decode<T: JSONDefaultWrapperAvailable>(_ type: JSONDefaultWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: DefaultWrapperStringConverterAvailable>(_ type: JSONDefaultWrapper.StringBoolConverter<T>.Type, forKey key: Key) throws -> JSONDefaultWrapper.StringBoolConverter<T> {
        let value = try decodeIfPresent(type, forKey: key)
        let result = value ?? .init()
            
            return result
    }
    
    
}


// MARK: - Test
class PropertyWrapperGeneric: Decodable {
    @JSONDefaultWrapper.DefaultTrue var isHiddenTrue
    @JSONDefaultWrapper.DefaultFalse var isHiddenFalse
    @JSONDefaultWrapper.DefaultZeroDouble var doubleValue: Double
    @JSONDefaultWrapper.DefaultZeroInt var intValue: Int
    @JSONDefaultWrapper.DefaultStringTrue var isStringTrue:Bool
    @JSONDefaultWrapper.DefaultStringFalse var isStringFalse
    
    
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
