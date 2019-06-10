//
//  Program.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift
import RxSwiftExt

public typealias Task<E, T> = Reader<E, Single<T>>
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
    static func app(_ message$: Observable<Message>) -> (Observable<(Model, Command)>) {
        return message$
            .scan((Model.initial, initialCommand)) { model_command, message -> (Self.Model, Command) in
                let (model, _) = model_command
                return update(model: model, message: message)
        }
    }
}

public extension Program {
    static func bind<V>(with view: V, environment: Environment) where V: View, V.Model == Model, V.Message == Message {
        let modelProxy: BehaviorSubject<Model> = BehaviorSubject(value: Model.initial)
        let commandProxy: BehaviorSubject<Cmd> = BehaviorSubject(value: initialCommand)
        
        let message$: Observable<Message> = Observable.merge(
            modelProxy.flatMap(view.run),
            commandProxy.flatMap(environment.run)
        )
        
        let model_command$: Observable<(Model, Cmd)> = app(message$)
            .share(replay: 1, scope: .forever)
        
        let modelDisposable = model_command$.map { $0.0 }.bind(to: modelProxy)
        let cmdDisposable = model_command$.map { $0.1 }.bind(to: commandProxy)
        
        let disposables = Disposables.create(modelDisposable, cmdDisposable)
        disposables.disposed(by: view.disposeBag)
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
