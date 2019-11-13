//
//  PersistentAdderViewController.swift
//  Example
//
//  Created by JinSeo Yoon on 11/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import Geppetto
import RxSwift
import RxSwiftExt

class NetworkingAdderEnvironment: EnvironmentType, HasURLSession {
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    static let shared: NetworkingAdderEnvironment = NetworkingAdderEnvironment()
}

enum NetworkingAdder: Program {
    typealias Environment = NetworkingAdderEnvironment
    
    enum Message {
        case updateLeftOperand(String?)
        case updateRightOperand(String?)
        case makeRequest
        case updateCalculationResult(Result<Int, Error>)
    }
    
    struct Model: ModelType, Copyable {
        var leftOperand: Int?
        var rightOperand: Int?
        var result: Int?
        var isLoading: Bool
        
        static var initial: Model {
            return Model(
                leftOperand: nil, 
                rightOperand: nil,
                result: nil,
                isLoading: false
            )
        }
    }
    
    static var initialCommand: Command { return .none }
    
    static func update(model: Model, message: Message) -> (Model, Command) {
        switch message {
        case let .updateLeftOperand(x):
            let value = x.flatMap(Int.init)
            return (
                model.copy { $0.leftOperand = value },
                .none
            )
            
        case let .updateRightOperand(x):
            let value = x.flatMap(Int.init)
            return (
                model.copy { $0.rightOperand = value },
                .none
            )
            
        case .makeRequest:
            return (
                model.copy {
                    $0.result = nil
                    $0.isLoading = true 
                },
                .none
            )
            
        case let .updateCalculationResult(.success(value)):
            return (
                model.copy { 
                    $0.result = value 
                    $0.isLoading = false
                },
                .none
            )
            
        case .updateCalculationResult(.failure):
            return (
                model.copy {  
                    $0.isLoading = false
                },
                .none
            )
        }
    }
    
    typealias ViewModel = String?
    
    static func view(model: Model) -> ViewModel {
        return model.resultText
    }
}

protocol NetworkingAdderViewModel {
    var resultText: String? { get }
}

extension NetworkingAdder.Model: NetworkingAdderViewModel {
    var resultText: String? { return result?.description }
}

class NetworkingAdderViewController: ViewController<NetworkingAdder> {
    @IBOutlet weak var leftOperandTextField: UITextField!
    @IBOutlet weak var rightOperandTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func behavior() {
        super.behavior()
        
        let updateLeftOperand$ = leftOperandTextField.rx.value
            .distinctUntilChanged()
            .map(Message.updateLeftOperand)
        
        let updateRightOperand$ = rightOperandTextField.rx.value
            .distinctUntilChanged()
            .map(Message.updateRightOperand)
        
        let input$ = Observable.merge(updateLeftOperand$, updateRightOperand$)            
        
        input$
            .bind(to: rx.dispatch)
            .disposed(by: disposeBag)
        
        rx.updated
            .map { $0.resultText }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

