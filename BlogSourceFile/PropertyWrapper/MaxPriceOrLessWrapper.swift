//
//  TwelveOrLess.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/13.
//

import Foundation

@propertyWrapper
struct MaxPriceOrLessWrapper {
    private var max: Int
    private var value: Int
    
    init(value: Int, maxPrice: Int) {
        self.max = maxPrice
        self.value = min(value, maxPrice)
    }
    
    var wrappedValue: Int {
        get { return value }
        set { value = min(newValue,max) }
    }
}

struct FoodTruck {
    @MaxPriceOrLessWrapper(value: 9000, maxPrice: 10000) var pizzaPrice: Int
    @MaxPriceOrLessWrapper(value: 12000, maxPrice: 10000) var pastaPrice: Int
    @MaxPriceOrLessWrapper(value: 7500, maxPrice: 10000) var chickenPrice: Int
    @MaxPriceOrLessWrapper(value: 400, maxPrice: 500) var soupPrice: Int
    @MaxPriceOrLessWrapper(value: 1000, maxPrice: 500) var kimchiPrice: Int
}


//struct FoodTruck {
//    private var maxPrice: Int = 10000
//    private var _pizzaPrice: Int
//    private var _pastaPrice: Int
//    private var _chickenPrice: Int
//    private var _soupPrice: Int
//    private var _kimchiPrice: Int
//
//
//    var pizzaPrice: Int {
//        get { return _pizzaPrice }
//        set { _pizzaPrice = min(newValue, maxPrice)}
//    }
//
//    var pastaPrice: Int {
//        get { return _pastaPrice }
//        set { _pastaPrice = min(newValue, maxPrice)}
//    }
//
//    var chickenPrice: Int {
//        get { return _chickenPrice }
//        set { _chickenPrice = min(newValue, maxPrice)}
//    }
//
//    var soupPrice: Int {
//        get { return _soupPrice }
//        set { _soupPrice = min(newValue, maxPrice)}
//    }
//
//    var kimchiPrice: Int {
//        get { return _kimchiPrice }
//        set { _kimchiPrice = min(newValue, maxPrice)}
//    }
//}
//
//struct FoodTruck2 {
//
//    enum Food {
//        case pizza
//        case pasta
//        case chicken
//        case soup
//        case kimchi
//    }
//
//    private var maxPrice: Int = 10000
//    private var pizzaPrice: Int
//    private var pastaPrice: Int
//    private var chickenPrice: Int
//    private var soupPrice: Int
//    private var kimchiPrice: Int
//
//    func getPrice(_ food: Food) -> Int {
//        switch food {
//        case .pizza: return pizzaPrice
//        case .pasta: return pastaPrice
//        case .chicken: return chickenPrice
//        case .soup: return soupPrice
//        case .kimchi: return kimchiPrice
//        }
//    }
//
//    mutating func setPrice(food: Food, price: Int) {
//        let realPrice = min(price, maxPrice)
//        switch food {
//        case .pizza: self.pizzaPrice = realPrice
//        case .pasta: self.pastaPrice = realPrice
//        case .chicken: self.chickenPrice = realPrice
//        case .soup: self.soupPrice = realPrice
//        case .kimchi: self.kimchiPrice = realPrice
//        }
//    }
//}
