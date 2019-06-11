//
//  Program.swift
//  LifeIsShort
//
//  Created by JinSeo Yoon on 2018. 3. 26..
//  Copyright © 2018년 Riiid. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

protocol DescriptiveEquatable: Equatable { }

extension DescriptiveEquatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return "\(lhs)" == "\(rhs)"
    }
}

class SantaEnvironment { }

protocol Program {
    associatedtype Dependency
    associatedtype Message
    associatedtype Model
    
    typealias Command = Reader<SantaEnvironment, Observable<Message?>>
    
    static func initialModel(from dependency: Dependency) -> Model
    static func initialCommand(with dependency: Dependency) -> Command
    static func update(model: Model, message: Message) -> (Model, Command)
    
    static func handleError(_ error: Error) -> Observable<Message?>
}

extension Program {
    static var env: Effect<SantaEnvironment, SantaEnvironment> {
        return Reader<SantaEnvironment, SantaEnvironment>.ask.map(Single.just)
    }
    
    static func bind(dependency: Dependency, environment: SantaEnvironment, viewController: ViewController2<Model, Message>) -> Disposable {
        let messageProxy: PublishSubject<Message?> = PublishSubject()        
        let (initModel, initEffect): (Model, Command) = (
            initialModel(from: dependency), 
            initialCommand(with: dependency)
        )
        
        let model_effect$: Observable<(Model, Command)> = messageProxy
            .scan((initModel, initEffect)) { model_effect, message -> (Self.Model, Command) in
                let (model, _) = model_effect
                guard let msg = message else { return (model, .none) }
                let (newModel, effects) = update(model: model, message: msg)
                return (newModel, effects)
            }
            .share(replay: 1, scope: .forever)
        
        let model$: Observable<Model> = attachDebugger(label: "model$", envSuffix: "MODEL")(model_effect$.map { $0.0 })
            .startWith(initModel)
        
        let effect$: Observable<Command> = attachDebugger(label: "effect$", envSuffix: "EFFECT")(model_effect$.map { $0.1 })
            .startWith(initEffect)
        
        let message$: Observable<Message> = attachDebugger(label: "message$", envSuffix: "MESSAGE")(Observable.merge([
            effect$
                .flatMap { reader in reader.run(environment).materialize() }
                .flatMap { event -> Observable<Message?> in
                    switch event {
                    case let .next(message):
                        return Observable.just(message)
                        
                    case let .error(error):
                        return handleError(error)
                        
                    default:
                        return Observable.just(nil)
                    }
                }
                .filterNil(),
            viewController.rx.event
            ])
        )
        
        let firstViewWillAppear$ = viewController.rx.viewWillAppear.take(1)
        
        let intentDisposable = firstViewWillAppear$
            .flatMap(const(message$))
            .bind(to: messageProxy)

        let viewModelDisposable = model$.bind(to: viewController.rx.update)
        
        return Disposables.create(intentDisposable, viewModelDisposable)
    }
}

extension Program {
    private static func attachDebugger<T>(label: String, envSuffix: String) -> (Observable<T>) -> Observable<T> {
        return { observable$ in
            if let debug = ProcessInfo.processInfo.environment["GEPETTO_PROGRAM_DEBUG_\(envSuffix)"], debug == "true" {
                return observable$.debug("\(Self.self): Gepetto.Program - \(label)")
            } else {
                return observable$
            }
        }
    }
}

class ProgramViewController<T>: ViewController2<T.Model, T.Message> where T: Program {
    typealias Message = T.Message
}
