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
