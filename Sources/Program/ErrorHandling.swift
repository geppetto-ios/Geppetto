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

public protocol ErrorHandler {
    associatedtype Environment: EnvironmentType
    associatedtype Message
    associatedtype Model: ModelType
    typealias Command = Cmd<Environment, Message?>
    
    static func handleError(_ error: Error, model: Model) -> (Model, Command)
}

public extension Program where Self: ErrorHandler {
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
                    let (newModel, command) = handleError(error, model: model)
                    return command.run(environment).map { (newModel, $0) }
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