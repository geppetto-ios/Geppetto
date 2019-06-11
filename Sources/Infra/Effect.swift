//
//  Effect.swift
//  LifeIsShort
//
//  Created by JinSeo Yoon on 23/05/2019.
//  Copyright © 2019 Riiid. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

typealias Effect<E, T> = Reader<E, Single<T>>

extension ReaderType where Value: RxSwift.PrimitiveSequenceType, Value.Trait == RxSwift.SingleTrait {
    func mapT<U>(_ f: @escaping (Value.Element) -> U) -> Reader<Env, Single<U>> {
        return map { single in single.primitiveSequence.map(f) }
    }

    func flatMapT<U>(_ transform: @escaping (Value.Element) -> Reader<Env, Single<U>>) -> Reader<Env, Single<U>> {
        return Reader<Env, Single<U>> { config in
            self.run(config).flatMap { transform($0).run(config) }
        }
    }

    func materialize() -> Reader<Env, Single<GPTResult<Value.Element>>> {
        return map { single in
            single.primitiveSequence.map(GPTResult<Value.Element>.success)
                .catchError { error -> Single<GPTResult<Value.Element>> in
                    let gptError = GPTError.underlying(error)
                    return Single.just(GPTResult<Value.Element>.failure(gptError))
            }
        }
    }

    func discard() -> Reader<Env, Single<Void>> {
        return mapT(const(()))
    }

    func with<U, V>(_ r: Reader<Env, Single<U>>, _ transform: @escaping (Value.Element, U) -> V) -> Reader<Env, Single<V>> {
        return batch(self, r).mapT(transform)
    }

    func andThen<U>(_ f: @escaping (Value.Element) -> Reader<Env, Single<U>>) -> Reader<Env, Single<U>> {
        return flatMapT(f)
    }

    func withMessage<U>(_ f: @escaping (Value.Element) -> U) -> Reader<Env, Observable<U>> {
        return map { $0.map(f).asObservable() }
    }

    func withoutMessage<U>() -> Reader<Env, Observable<U?>> {
        return withMessage(const(nil))
    }

    func asCommand() -> Reader<Env, Observable<Value.Element>> {
        return withMessage(id)
    }

    func toCommand<U>(_ f: @escaping (Value.Element) -> Reader<Env, Observable<U>>) -> Reader<Env, Observable<U>> {
        return Reader<Env, Observable<U>> { env in
            self.run(env).primitiveSequence.asObservable().flatMap { f($0).run(env) }
        }
    }
}

extension Reader where T: PrimitiveSequenceType, T.Trait == SingleTrait {
    static func just<T: OptionalType>(_ x: T) -> Effect<E, T?> { return Effect<E, T?>.init(run: const(Single<T?>.just(x))) }
    static func just<T>(_ x: T) -> Effect<E, T> { return Effect<E, T>.init(run: const(Single<T>.just(x))) }
}

func batch<E, R1, R2>(_ r1: R1, _ r2: R2) ->
    Reader<E, Single<(R1.Value.Element, R2.Value.Element)>> where
    R1: ReaderType, R1.Env == E, R1.Value: PrimitiveSequenceType, R1.Value.Trait == SingleTrait,
    R2: ReaderType, R2.Env == E, R2.Value: PrimitiveSequenceType, R2.Value.Trait == SingleTrait {
        return Reader.zipCommon(r1, r2)
            .map { (arg) -> Single<(R1.Value.Element, R2.Value.Element)> in
                let (s1, s2) = arg
                return Single.zip(s1.primitiveSequence, s2.primitiveSequence)
        }
}

func batch<E, R1, R2, R3>(_ r1: R1, _ r2: R2, _ r3: R3) ->
    Reader<E, Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element)>> where
    R1: ReaderType, R1.Env == E, R1.Value: PrimitiveSequenceType, R1.Value.Trait == SingleTrait,
    R2: ReaderType, R2.Env == E, R2.Value: PrimitiveSequenceType, R2.Value.Trait == SingleTrait,
    R3: ReaderType, R3.Env == E, R3.Value: PrimitiveSequenceType, R3.Value.Trait == SingleTrait {
        return Reader.zipCommon(r1, r2, r3)
            .map { (arg) -> Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element)> in
                let (s1, s2, s3) = arg
                return Single.zip(s1.primitiveSequence, s2.primitiveSequence, s3.primitiveSequence)
        }
}

func merge<E, R>(_ readers: [R]) -> Reader<E, Observable<R.Value.Element>> where
    R: ReaderType, R.Env == E, R.Value: ObservableType {
        return Reader.zipCommon(readers).map { xs in Observable.from(xs).merge() }
}

func merge<E, R>(_ readers: R...) -> Reader<E, Observable<R.Value.Element>> where
    R: ReaderType, R.Env == E, R.Value: ObservableType {
        return Reader.zipCommon(readers).map { xs in Observable.from(xs).merge() }
}
