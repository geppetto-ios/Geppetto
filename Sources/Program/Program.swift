//
//  Program.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift
import RxSwiftExt

public typealias Cmd<E, T> = Reader<E, Observable<T>>

public protocol ModelType {
    static var initial: Self { get }
}

public protocol Program {
    associatedtype Environment: EnvironmentType
    associatedtype Message
    associatedtype Model: ModelType
    typealias Command = Cmd<Environment, Message?>
    
    static var initialCommand: Command { get }
    static func update(model: Model, message: Message) -> (Model, Command)
}

public extension Program {
    static var env: Effect<Environment, Environment> {
        return Reader<Environment, Single<Environment>>(run: Single.just)
    }
}

public extension Program {
    static func app(_ message$: Observable<Message>) -> (Observable<(Model, Command)>) {
        return message$
            .scan((Model.initial, initialCommand)) { model_command, message -> (Self.Model, Command) in
                let (model, _) = model_command
                return update(model: model, message: message)
            }
            .startWith((Model.initial, initialCommand))
    }
}

public extension Program {
    static func bind<V>(with view: V, environment: Environment) where V: View, V.Model == Model, V.Message == Message {
        let messageProxy: PublishSubject<Message> = PublishSubject()
        
        let model_command$: Observable<(Model, Command)> = app(messageProxy)
            .share(replay: 1, scope: .forever)
        
        let model$: Observable<Model> = model_command$.map { $0.0 }
        let command$: Observable<Command> = model_command$.map { $0.1 }
        
        let message$: Observable<Message> = Observable.merge(
            model$.flatMapLatest(view.run),
            command$.flatMap(environment.run)
        )
        
        view.didReady$
            .asObservable()
            .flatMap(const(message$))
            .bind(to: messageProxy)
            .disposed(by: view.disposeBag) 
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait {
    func withMessage<Message>(_ f: @escaping (Value.Element) -> Message) -> Cmd<Env, Message?> {
        return map { return $0.map(f).asObservable() }
    }
    
    func withoutMessage<Message>() -> Cmd<Env, Message?> {
        return map { return $0.map { _ in nil }.asObservable() }
    }
}
