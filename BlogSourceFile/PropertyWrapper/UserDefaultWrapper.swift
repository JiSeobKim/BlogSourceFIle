//
//  UserDefaultWrapper.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/12.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    private let ud = UserDefaults.standard
    private let key: String
    private var defaultValue: T
    
    
    var wrappedValue: T {
        get {
            return ud.value(forKey: key) as? T ?? defaultValue
        }
        set {
            ud.setValue(newValue, forKey: key)
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}


struct UserDefaultManager {
    @UserDefaultWrapper(key: "usrNm", defaultValue: "")
    static var usrNm: String
}
