//
//  BeginnerProgram.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 07/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift

public protocol HasUI {
    associatedtype Model
    associatedtype ViewModel
    
    static func view(model: Model) -> ViewModel
}

public protocol BeginnerProgram: StateMachine, HasUI { }

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
