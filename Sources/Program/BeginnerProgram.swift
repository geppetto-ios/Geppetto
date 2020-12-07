//
//  BeginnerProgram.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 07/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift

public protocol BeginnerProgram: Program where Environment == Unit {
    static func update(model: Model, message: Message) -> Model
}

public extension BeginnerProgram {
    static var initialCommand: Command {
        return .none
    }
    
    static func update(model: Model, message: Message) -> (Model, Command) {
        return (update(model: model, message: message), .none)
    }
}

public extension BeginnerProgram {
    static func bind<V>(with v: V, environment: Environment) where V: View, V.Model == ViewModel, V.Message == Message {
        let messageProxy: PublishSubject<Message> = PublishSubject()
        
        let model_command$: Observable<(Model, Command)> = app(messageProxy)
            .share(replay: 1, scope: .forever)
        
        let model$: Observable<Model> = model_command$.map { $0.0 }
        let command$: Observable<Command> = model_command$.map { $0.1 }
        
        let message$: Observable<Message> = Observable.merge(
            model$.map(view).flatMapLatest(v.run),
            command$.flatMap(environment.run)
        )
        
        message$.bind(to: messageProxy).disposed(by: v.disposeBag) 
    }
}
