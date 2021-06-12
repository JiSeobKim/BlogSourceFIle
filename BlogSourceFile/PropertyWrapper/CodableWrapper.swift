//
//  CodableWrapper.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/12.
//

import Foundation


@propertyWrapper
struct APIStringBool {
    let wrappedValue: Bool
}

extension APIStringBool: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringBool = try? container.decode(String.self)
        wrappedValue = stringBool == "Y"
    }
}
