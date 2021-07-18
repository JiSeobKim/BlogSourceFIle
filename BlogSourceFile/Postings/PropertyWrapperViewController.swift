//
//  PropertyWrapperViewController.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/12.
//

import UIKit
import JsJsonDecoderWrapper

class PropertyWrapperViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        runFoodTruct()
//        runUserDefaultWrapper()
//        testCodable()
//        highWrapper()
//        postingFunction1()
        
//        PropertyWrapperGeneric.test()
//        WrapperPosting1.run()
        Posting2.test()
    }
    

    
}

//// MARK: - Posting
//extension PropertyWrapperViewController {
//    /// 포스팅 1
//    func postingFunction1() {
//        struct Model: Codable {
//            @StringBoolConverter var isHidden: Bool
//        }
//
//        let jsonData = """
//            {
//                "isHidden" : "Y"
//            }
//            """.data(using: .utf8)!
//
//        let result = try! JSONDecoder().decode(Model.self, from: jsonData)
//
//        print("isHidden: \(result.isHidden)")
//
//    }
//}
//
//// MARK: - Practice
//extension PropertyWrapperViewController {
//    struct Model: Codable {
//        let userName: String
//        @StringBoolConverter var isHidden: Bool
//        @ZeroDefault var intValue: Int
//        @ZeroDefault var doubleValue: Double
//    }
//
//    struct EmptyModel: Decodable {
//        @DecodableDefault.EmptyString var valueOfString: String
//        @DecodableDefault.True var valueOfTrueBool: Bool
//        @DecodableDefault.False var valueOfFalseBool: Bool
//        @DecodableDefault.EmptyList var valueOfList: [String]
//        @DecodableDefault.EmptyMap var valueOfDictionary: [String:String]
//    }
//
//    /// FoodTruck
//    private func runFoodTruct() {
//        var truck = FoodTruck()
//        print("""
//        pizzaPrice: \(truck.pizzaPrice)
//        pastaPrice: \(truck.pastaPrice)
//        chickenPrice: \(truck.chickenPrice)
//        soupPrice: \(truck.soupPrice)
//        kimchiPrice: \(truck.kimchiPrice)
//        """)
//
//        truck.pizzaPrice = 12000
//        truck.pastaPrice = 8000
//        truck.chickenPrice = 20000
//        truck.soupPrice = 500
//        truck.kimchiPrice = 7500
//
//
//        print("""
//        \n
//        pizzaPrice: \(truck.pizzaPrice)
//        pastaPrice: \(truck.pastaPrice)
//        chickenPrice: \(truck.chickenPrice)
//        soupPrice: \(truck.soupPrice)
//        kimchiPrice: \(truck.kimchiPrice)
//        """)
//    }
//
//
//    /// UserDefault 적용
//    private func runUserDefaultWrapper() {
//        // 출력해보기
//        print("값 변경 전")
//        print("userName: \(UserDefaultManager.userName)")
//        print("hasMembership: \(UserDefaultManager.hasMembership)")
//
//        // 값 넣기
//        UserDefaultManager.userName = "KJS"
//        UserDefaultManager.hasMembership = true
//
//        // 출력해보기
//        print("\n값 변경 후")
//        print("userName: \(UserDefaultManager.userName)")
//        print("hasMembership: \(UserDefaultManager.hasMembership)")
//    }
//
//
//    /// 코더블 기본값 적용
//    private func testCodable() {
//        // 1. 통신 결과값
//        let response = DummyJsonLoader.load(api: .dataType)!
//
//        do {
//            // 2. Codable을 이용한 모델 얻기
//            let value = try JSONDecoder().decode(Model.self, from: response)
//            // 3. 결과 출력
//            let result = """
//                userNm = \(value.userName),
//                isHidden = \(value.isHidden),
//                intValue = \(value.intValue),
//                doubleValue = \(value.doubleValue)
//                """
//
//            print(result)
//
//        } catch (let error) {
//            // 4. 오류 출력
//            print(error)
//        }
//    }
//
//    /// wrapper 고급
//    private func highWrapper() {
//        guard let data = DummyJsonLoader.load(api: .dataType) else { return }
//
//        do {
//            let value = try JSONDecoder().decode(EmptyModel.self, from: data)
//            print("""
//                value: \(value.valueOfTrueBool),
//                value: \(value.valueOfFalseBool),
//                value: \(value.valueOfString),
//                value: \(value.valueOfList),
//                value: \(value.valueOfDictionary)
//                """)
//        } catch let e {
//            print(e.localizedDescription)
//        }
//    }
//}
