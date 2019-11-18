//
//  ExampleListViewController.swift
//  Example
//
//  Created by JinSeo Yoon on 11/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit

class ExampleListViewController: UITableViewController {
    enum SegueIdentifier: String {
        case showSimpleAdder
        case showPersistentAdder
        case showNetworkingAdder
        case showErrorHandlingAdder
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier.flatMap(SegueIdentifier.init) else { return }
        switch segueId {
        case .showSimpleAdder:
            if 
                let vc = segue.destination as? SimpleAdderViewController {
                SimpleAdder.bind(with: vc)
            }
            
        case .showPersistentAdder:
            if 
                let vc = segue.destination as? PersistentAdderViewController {
                PersistentAdder.bind(with: vc, environment: .shared)
            }
            
        case .showNetworkingAdder:
            if 
                let vc = segue.destination as? NetworkingAdderViewController {
                NetworkingAdder.bind(with: vc, environment: .shared)
            }
            
        case .showErrorHandlingAdder:
            if 
                let vc = segue.destination as? ErrorHandlingAdderViewController {
                ErrorHandlingAdder.bind(with: vc, environment: .shared)
            }
        }
    }
}
