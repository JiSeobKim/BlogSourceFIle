//
//  SPMMakeViewController.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/07/31.
//

import UIKit
import JSLibrary

class SPMMakeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTest()
    }
    
    func createTest() {
        let library = JSLibrary()
        print(library.publicText)
    }

}
