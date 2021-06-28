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
    func decode(_ type: ZeroDefault<Double>.Type,
                forKey key: Key) throws -> ZeroDefault<Double> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: StringBoolConverter.Type,
                forKey key: Key) throws -> StringBoolConverter {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}


// MARK: - Use Enum

protocol ZeroDefaultAvailable {
    associatedtype Test: Decodable
    static var `defaultValue`: Test { get }
}

enum ZeroDefaultWrapper {}

extension ZeroDefaultWrapper {
    
    @propertyWrapper
    struct Wrapper<T: ZeroDefaultAvailable> {
        typealias Test = T.Test
        var wrappedValue = T.defaultValue
    }
}

extension ZeroDefaultWrapper.Wrapper: Decodable{
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(T.Test.self)
    }
}


extension KeyedDecodingContainer {
    func decode<T: Numeric>(_ type: ZeroDefaultWrapper.Wrapper<T>.Type,
                forKey key: Key) throws -> ZeroDefaultWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
        
    }
}
