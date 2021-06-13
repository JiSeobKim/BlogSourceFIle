//
//  UserDefaultWrapper.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/12.
//

import Foundation

//@propertyWrapper
//struct UserDefaultWrapper<T> {
//    private let ud = UserDefaults.standard
//    private let key: String
//    private var defaultValue: T
//
//
//    var wrappedValue: T {
//        get {
//            return ud.value(forKey: key) as? T ?? defaultValue
//        }
//        set {
//            ud.setValue(newValue, forKey: key)
//        }
//    }
//
//    init(key: String, defaultValue: T) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//}

@propertyWrapper
struct UserDefaultWrapper<T> { // 1. 여기에 제네릭 써주고
    private let ud = UserDefaults.standard
    private let key: String
    // 2. 여기도 제네릭 써주고
    private var defaultValue: T
    
    // 3. 여기도 제네릭 써주고
    var wrappedValue: T {
        get {
            // 4. 여기도 제네릭 써주고
            return ud.value(forKey: key) as? T ?? defaultValue
        }
        set {
            ud.setValue(newValue, forKey: key)
        }
    }
    
    // 5. 여기도 제네릭 써주고
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}


//struct UserDefaultManager {
//    @UserDefaultWrapper(key: "usrNm", defaultValue: "")
//    static var usrNm: String
//}

// MARK: - Before
//struct UserDefaultManager {
//    private static var ud = UserDefaults.standard
//
//    static var userName: String {
//        get {
//            return ud.value(forKey: "userName") as? String ?? ""
//        }
//        set {
//            ud.setValue(newValue, forKey: "userName")
//        }
//    }
//
//    static var hasMembership: Bool {
//        get {
//            return ud.value(forKey: "hasMembership") as? Bool ?? false
//        }
//        set {
//            ud.setValue(newValue, forKey: "hasMembership")
//        }
//    }
//}

// MARK: After
struct UserDefaultManager {
    private static var ud = UserDefaults.standard
    
    @UserDefaultWrapper(key: "userName", defaultValue: "")
    static var userName: String
    
    @UserDefaultWrapper(key: "hasMembership", defaultValue: false)
    static var hasMembership: Bool
}
