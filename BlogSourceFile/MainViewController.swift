//
//  MainViewController.swift
//  BlogSourceFile
//
//  Created by 김지섭 on 2021/05/30.
//

import UIKit

class MainViewController: UIViewController {
    
    enum CellInfo: String, CaseIterable {
        case codingKey = "CodingKey 포스팅"
        case codableThrow = "Codable Throw 포스팅"
        case propertyWrapper = "Property Wrapper 포스팅"
        
        var segueID: String {
            switch self {
            case .codingKey: return "CodingKey"
            case .codableThrow: return "CodableThrow"
            case .propertyWrapper: return "PropertyWrapper"
            }
        }
        
        var cellID: String { return "Cell" }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var cellInfos: [CellInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellInfos = CellInfo.allCases
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = cellInfos[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: info.cellID, for: indexPath)
        let label = cell.viewWithTag(1) as? UILabel
        let title = info.rawValue
        
        label?.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = cellInfos[indexPath.row]
        performSegue(withIdentifier: info.segueID, sender: nil)
    }
}
