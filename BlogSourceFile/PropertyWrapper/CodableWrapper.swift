//
//  CodableWrapper.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/12.
//

import Foundation


@propertyWrapper
struct StringBoolConverter {
    let wrappedValue: Bool
}

extension StringBoolConverter: Codable {
    init() {
        wrappedValue = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringBool = try? container.decode(String.self)
        wrappedValue = stringBool == "Y"
    }
}


@propertyWrapper
struct ZeroDefault<T: Numeric> {
    var wrappedValue: T
    
    
}


extension ZeroDefault: Codable where T: Codable  {
    init() {
        wrappedValue = 0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        self.wrappedValue = try container.decode(T.self)
        
    }
}


extension KeyedDecodingContainer {
    func decode(_ type: ZeroDefault<Int>.Type,
                forKey key: Key) throws -> ZeroDefault<Int> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: ZeroDefault<Double>.Type,
                forKey key: Key) throws -> ZeroDefault<Double> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: StringBoolConverter.Type, forKey key: Key) throws -> StringBoolConverter {
        let value = try decodeIfPresent(type, forKey: key) ?? .init()
        return value
    }
}


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



struct CodableDefault {
    
    typealias True = Wrapper<DefaultType.True>
    
    @propertyWrapper
    struct Wrapper<T: DecodableDefaultSource> {
        typealias Value = T.Value
        var wrappedValue = T.defaultValue
    }
    
    
    enum DefaultType {
        enum True: DecodableDefaultSource {
            typealias Value = Bool
            static var defaultValue: Value { true }
        }
        enum False: DecodableDefaultSource {
            static var defaultValue: Bool { false }
        }
    }
}


protocol WrapperDefaultAvailable {
    
}

//
//enum WrapperDefault {
//    @propertyWrapper
//    struct Wrapper {
//
//    }
//
//}
