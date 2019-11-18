//
//  ComposableAdderViewController.swift
//  Example
//
//  Created by JinSeo Yoon on 18/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import Geppetto

enum CompositeAdder: Program, ErrorHandlingProgram {
    typealias Environment = ErrorHandlingAdderEnvironment
    
    enum Message {
        case adder1Message(ErrorHandlingAdder.Message)
        case adder2Message(ErrorHandlingAdder.Message)
    }
    
    struct Model: RecoverableModel, Copyable {
        var adder1Model: ErrorHandlingAdder.Model = .initial
        var adder2Model: ErrorHandlingAdder.Model = .initial
        
        static var initial: Model { return Model() }
        
        func recover(from error: Error) -> Model {
            return copy { 
                $0.adder1Model = $0.adder1Model.recover(from: error)
                $0.adder2Model = $0.adder2Model.recover(from: error)
            }
        }
    }
    
    static var initialCommand: Command { 
        return merge(
            ErrorHandlingAdder.initialCommand.mapT { $0.map(Message.adder1Message) },
            ErrorHandlingAdder.initialCommand.mapT { $0.map(Message.adder2Message) }
        ) 
    }
    
    static func update(model: Model, message: Message) -> (Model, Command) {
        switch message {
        case let .adder1Message(x):
            let (subModel, subCommand) = ErrorHandlingAdder.update(model: model.adder1Model, message: x)
            return (
                model.copy {
                    $0.adder1Model = subModel
                }, 
                subCommand.mapT { $0.map(Message.adder1Message) }
            )
            
        case let .adder2Message(x):
            let (subModel, subCommand) = ErrorHandlingAdder.update(model: model.adder2Model, message: x)
            return (
                model.copy {
                    $0.adder2Model = subModel
                }, 
                subCommand.mapT { $0.map(Message.adder2Message) }
            )
        }
    }
    
    static func handleError(_ error: Error) -> Effect<Environment, Error> {
        return env.alert(error: error)
    }
    
    typealias ViewModel = Model
    
    static func view(model: Model) -> ViewModel {
        return model
    }
}

class CompositeAdderViewController: ViewController<ErrorHandlingAdder> {  
    override func style() {
        super.style()
        
    }
    
    override func behavior() {
        super.behavior()
        
    }
}
