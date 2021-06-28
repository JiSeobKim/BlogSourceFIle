//
//  PropertyWrapper_High.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/27.
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
