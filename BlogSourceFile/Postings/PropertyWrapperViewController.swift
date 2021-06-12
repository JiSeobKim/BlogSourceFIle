//
//  PropertyWrapperViewController.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/06/12.
//

import UIKit

class PropertyWrapperViewController: UIViewController {
    
    struct Model: Codable {
        let userName: String
        @APIStringBool var isHidden: Bool
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        runUserDefaultWrapper()
        testCodable()
    }
    

    
    private func runUserDefaultWrapper() {
        print(UserDefaultManager.usrNm)
    }

    
    // 테스트
    private func testCodable() {
        // 1. 통신 결과값
        let response = DummyJsonLoader.load(api: .dataType)!
        
        do {
            // 2. Codable을 이용한 모델 얻기
            let value = try JSONDecoder().decode(Model.self, from: response)
            // 3. 결과 출력
            let result = """
                userNm = \(value.userName),
                isHidden = \(value.isHidden)
                """
            
            print(result)
            
        } catch (let error) {
            // 4. 오류 출력
            print(error)
        }
    }
}
