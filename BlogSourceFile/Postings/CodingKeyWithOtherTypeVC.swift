//
//  ViewController.swift
//  test
//
//  Created by kimjiseob on 25/07/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import UIKit

class CodingKeyWithOtherTypeVC: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    struct Model: Codable {
        let userName: String
        let isHidden: Bool
        
        enum CodingKeys: String, CodingKey {
            case userName
            case isHidden
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.userName = try container.decode(String.self, forKey: .userName)
            self.isHidden = try container.decode(String.self, forKey: .isHidden) == "Y"
        }
    }
    
    struct Model2: Codable {
        let userName: String
        let sequenceNo: Int
        let orderNo: Int
        let address: String
        
        enum CodingKeys: String, CodingKey {
            case userName = "usrNm"
            case sequenceNo = "seqNo"
            case orderNo = "ordNo"
            case address = "addr"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testDiffType()
        
    }
    
    
    func testCondingKey() {
        // 1. 통신 결과값
        let response = DummyJsonLoader.load(api: .postingAPI)!
        
        do {
            // 2. Codable을 이용한 모델 얻기
            let value = try JSONDecoder().decode(Model2.self, from: response)
            // 3. 결과 출력
            let result = """
                userNm = \(value.userName),
                sequenceNo = \(value.sequenceNo),
                orderNo = \(value.orderNo),
                address = \(value.address),
                """
                
            print(result)
            resultLabel.text = result
            
            
        } catch (let error) {
            // 4. 오류 출력
            print(error)
        }
    }
    
    // 테스트
    func testDiffType() {
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
            resultLabel.text = result
            
        } catch (let error) {
            // 4. 오류 출력
            print(error)
        }
    }
}






