//
//  Command.swift
//  LifeIsShort
//
//  Created by 윤진서 on 23/05/2019.
//  Copyright © 2019 Riiid. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

typealias Cmd<E, T> = Reader<E, Observable<T>>

extension ReaderType where Value: RxSwift.ObservableType {
    func mapT<U>(_ f: @escaping (Value.Element) -> U) -> Reader<Env, Observable<U>> {
        return map { observable in observable.map(f) }
    }
    
    func flatMapT<U>(_ transform: @escaping (Value.Element) -> Reader<Env, Observable<U>>) -> Reader<Env, Observable<U>> {
        return Reader<Env, Observable<U>> { config in
            self.run(config).flatMap { transform($0).run(config) }
        }
    }
    
    func materialize() -> Reader<Env, Observable<GPTResult<Value.Element>>> {
        return map { x$ in
            x$.map(GPTResult<Value.Element>.success)
                .catchError { error -> Observable<GPTResult<Value.Element>> in
                    let gptError = GPTError.underlying(error)
                    return Observable.just(GPTResult<Value.Element>.failure(gptError))
            }
        }
    }
    
    func discard() -> Reader<Env, Observable<Void>> {
        return mapT(const(()))
    }
}

extension ReaderType where Value: ObservableType, Value.Element: OptionalType {
    func mapTT<U>(_ f: @escaping (Value.Element.Wrapped) -> U) -> Reader<Env, Observable<U?>> {
        return map { $0.map { $0.value.map(f) } }
    }

    func liftMessage<U>(_ f: @escaping (Value.Element.Wrapped) -> U) -> Reader<Env, Observable<U?>> {
        return mapTT(f)
    }
}

extension ReaderType where Value: ObservableType {
    static func just<T: OptionalType>(_ x: T) -> Cmd<Env, T?> { return Cmd<Env, T?>.init(run: const(Observable<T?>.just(x))) }
    static func just<T>(_ x: T) -> Cmd<Env, T> { return Cmd<Env, T>.init(run: const(Observable<T>.just(x))) }
}

extension ReaderType where Value: ObservableType, Value.Element: OptionalType {
    static var none: Cmd<Env, Value.Element.Wrapped?> { return Cmd { _ in Observable.just(nil) } }
}
