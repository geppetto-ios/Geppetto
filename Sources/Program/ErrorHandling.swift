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
    
    static func handleError(_ error: Error) -> Command
}

public extension Program where Self: ErrorHandler {
    static func bind<V>(with view: V, environment: Environment) where V: View, V.Model == Model, V.Message == Message {
        let messageProxy: PublishSubject<Message> = PublishSubject()
        
        let model_command$: Observable<(Model, Command)> = app(messageProxy)
            .share(replay: 1, scope: .forever)
        
        let model$: Observable<Model> = model_command$.map { $0.0 }
        let command$: Observable<Command> = model_command$.map { $0.1 }
        
        let messageFromCommand$: Observable<Message?> = command$
            .flatMap { (command: Command) -> Observable<Event<Message?>> in  
                return command.run(environment).materialize()
            }            
            .flatMap { event -> Observable<Message?> in
                switch event {
                case let .next(x):
                    return Observable.just(x)
                case let .error(error):
                    let command = handleError(error)
                    return command.run(environment)
                case .completed:
                    return Observable.just(nil)
                }
            }
            
        let message$: Observable<Message> = Observable.merge(
            model$.flatMapLatest(view.run),
            messageFromCommand$.unwrap()
        )
        
        view.didReady$
            .asObservable()
            .flatMap(const(message$))
            .bind(to: messageProxy)
            .disposed(by: view.disposeBag) 
    }
}
