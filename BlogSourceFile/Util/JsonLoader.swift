//
//  JsonLoader.swift
//  test
//
//  Created by 김지섭 on 2021/05/16.
//  Copyright © 2021 kimjiseob. All rights reserved.
//

import Foundation


class JsonLoader {
    
}

//
//  DummyJsonLoader.swift
//  uTicket
//
//  Created by kimjiseob on 2020/12/07.
//  Copyright © 2020 김지섭. All rights reserved.
//


class DummyJsonLoader {
    enum API: String {
        case postingAPI = "PostingJSON"
        case dataType = "DataTypeJSON"
    }
    
    
    static func load(api: API) -> Data? {
        let extensionType = "json"

        let resource: String = api.rawValue
        
        guard let fileLocation = Bundle.main.url(forResource: resource, withExtension: extensionType) else { return nil }
        
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
    
    
    static func load<T: Codable> (api: API, type: T.Type) -> T? {
        
        guard let data = load(api: api) else { return nil }
        
        do {
            let decodeData = try JSONDecoder().decode(type, from: data)
            return decodeData
        } catch {
            return nil
        }
        
    }
}
