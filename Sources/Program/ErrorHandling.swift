//
//  ErrorHandling.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 15/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

public protocol RecoverableModel: ModelType {
    func recover(from error: Error) -> Self
}

public protocol ErrorHandlingProgram: Program where Self.Model: RecoverableModel {
    static func handleError(_ error: Error) -> Effect<Environment, Error>
}

public extension ErrorHandlingProgram {
    static func bind<V>(with view: V, environment: Environment) where V: View, V.Model == Model, V.Message == Message {
        let messageProxy: PublishSubject<Message> = PublishSubject()
        
        let model_command$: Observable<(Model, Command)> = app(messageProxy)
            .share(replay: 1, scope: .forever)
        
        let model$: Observable<Model> = model_command$.map { $0.0 }
        let command$: Observable<Command> = model_command$.map { $0.1 }
        
        let messageFromCommand$: Observable<(Model?, Message?)> = command$
            .flatMap { (command: Command) -> Observable<Event<Message?>> in command.run(environment).materialize() }
            .withLatestFrom(model$) { ($0, $1) }
            .flatMap { event, model -> Observable<(Model?, Message?)> in
                switch event {
                case let .next(x):
                    return Observable.just((nil, x))
                case let .error(error):
                    let effect = handleError(error)
                    let newModel = model.recover(from: error)
                    return effect.run(environment).asObservable().map { _ in (newModel, nil) }
                case .completed:
                    return Observable.just((nil, nil))
                }
            }
            .share(replay: 1, scope: .forever)
        
        let recoveredModel$: Observable<Model> = messageFromCommand$.map { $0.0 }.unwrap()
        let mergedModel$: Observable<Model> = Observable.merge(
            model$,
            recoveredModel$
        )
            
        let message$: Observable<Message> = Observable.merge(
            mergedModel$.flatMapLatest(view.run),
            messageFromCommand$.map { $1 }.unwrap()
        )
        
        view.didReady$
            .asObservable()
            .flatMap(const(message$))
            .bind(to: messageProxy)
            .disposed(by: view.disposeBag) 
    }
}
