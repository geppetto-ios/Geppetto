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

class PersistentAdderEnvironment: EnvironmentType, HasUserDefaults {
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    static let shared: PersistentAdderEnvironment = PersistentAdderEnvironment()
}

enum PersistentAdder: Program {
    enum UserDefaultKey: String {
        case leftOperand
        case rightOperand
    }
    
    typealias Environment = PersistentAdderEnvironment
    
    enum Message {
        case updateInitialOperands(Int?, Int?)
        case updateLeftOperand(String?)
        case updateRightOperand(String?)
    }
    
    struct Model: ModelType, Copyable {
        var leftOperand: Int?
        var rightOperand: Int?
        
        var result: Int? { return leftOperand.flatMap { x in rightOperand.map { y in x + y } } }
        
        static var initial: Model {
            return Model(
                leftOperand: nil, 
                rightOperand: nil
            )
        }
    }
    
    static var initialCommand: Command { 
        return batch(
            env.userDefaults.value(for: UserDefaultKey.leftOperand.rawValue, of: Int.self),
            env.userDefaults.value(for: UserDefaultKey.rightOperand.rawValue, of: Int.self)
        ).withMessage(Message.updateInitialOperands)
    }
    
    static func update(model: Model, message: Message) -> (Model, Command) {
        switch message {
        case let .updateInitialOperands(left, right):
            return (model.copy {
                $0.leftOperand = left
                $0.rightOperand = right
            }, .none)
            
        case let .updateLeftOperand(x):
            let value = x.flatMap(Int.init)
            return (
                model.copy { $0.leftOperand = value },
                env.userDefaults
                    .setValue(value, for: UserDefaultKey.leftOperand.rawValue)
                    .withoutMessage()
            )
            
        case let .updateRightOperand(x):
            let value = x.flatMap(Int.init)
            return (
                model.copy { $0.rightOperand = value },
                env.userDefaults
                    .setValue(value, for: UserDefaultKey.rightOperand.rawValue)
                    .withoutMessage()
            )
        }
    }
    
    typealias ViewModel = String?
    
    static func view(model: Model) -> ViewModel {
        return model.resultText
    }
}

protocol PersistentAdderViewModel {
    var leftOperandText: String? { get }
    var rightOperandText: String? { get }
    var resultText: String? { get }
}

extension PersistentAdder.Model: PersistentAdderViewModel {
    var rightOperandText: String? { return rightOperand?.description }
    var leftOperandText: String? { return leftOperand?.description }
    var resultText: String? { return result?.description }
}

class PersistentAdderViewController: ViewController<PersistentAdder> {
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
            .map { $0.leftOperandText }
            .bind(to: leftOperandTextField.rx.text)
            .disposed(by: disposeBag)
        
        rx.updated
            .map { $0.rightOperandText }
            .bind(to: rightOperandTextField.rx.text)
            .disposed(by: disposeBag)
        
        rx.updated
            .map { $0.resultText }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

