//
//  StateMachine.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift

extension Unit: EnvironmentType { }

public protocol StateMachine: Program where Environment == Unit {
    static func update(model: Model, message: Message) -> Model 
}

public extension StateMachine {
    static var initialCommand: Command {
        return .none
    }
    
    static func update(model: Model, message: Message) -> (Model, Command) {
        return (update(model: model, message: message), .none)
    }
}

public extension StateMachine {
    static func bind<V>(with view: V, dependency: Dependency) where V: View, V.Model == ViewModel, V.Message == Message {
        bind(with: view, dependency: dependency, environment: Unit())
    }
}
