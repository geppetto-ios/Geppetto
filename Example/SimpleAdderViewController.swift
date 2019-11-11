//
//  ViewController.swift
//  Example
//
//  Created by Riiid_Pilgwon on 10/06/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import Geppetto
import RxSwift
import RxSwiftExt

enum SimpleAdder: BeginnerProgram {
    enum Message {
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
    
    static func update(model: Model, message: Message) -> Model {
        switch message {
        case let .updateLeftOperand(left):
            return model.copy {
                $0.leftOperand = left.flatMap(Int.init)
            }
            
        case let .updateRightOperand(right):
            return model.copy {
                $0.rightOperand = right.flatMap(Int.init)
            }
        }
    }
    
    typealias ViewModel = String?
    
    static func view(model: Model) -> ViewModel {
        return model.resultText
    }
}

extension SimpleAdder.Model {
    var resultText: String? {
        return result?.description
    }
}

class SimpleAdderViewController: ViewController<SimpleAdder> {
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
