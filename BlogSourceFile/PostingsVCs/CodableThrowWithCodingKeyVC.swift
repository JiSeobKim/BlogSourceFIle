//
//  CodableThrowWithCodingKeyVC.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/05/30.
//

import UIKit

class CodableThrowWithCodingKeyVC: UIViewController {
    
    
    struct Model: Codable {
        let sequenceNo: Int?
        let name: String
        
        enum CodingKeys: String, CodingKey {
            case sequenceNo, name
        }
        
        init(from decoder: Decoder) throws {
            let contianer = try decoder.container(keyedBy: CodingKeys.self)
            self.sequenceNo = try contianer.decodeIfPresent(Int.self, forKey: .sequenceNo)
            self.name = try contianer.decode(String.self, forKey: .name)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let model = loadData() else { return }
        print(model)
    }
    
    func loadData() -> Model? {
        let data = DummyJsonLoader.load(api: .codableThrow, type: Model.self)
        return data
    }
}
