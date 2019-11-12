//
//  Effect.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 11/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift

public typealias Effect<E, T> = Reader<E, Single<T>>

public func batch<E, R1, R2>(_ r1: R1, _ r2: R2) ->
    Reader<E, Single<(R1.Value.Element, R2.Value.Element)>> where
    R1: ReaderType, R1.Env == E, R1.Value: PrimitiveSequenceType, R1.Value.Trait == SingleTrait,
    R2: ReaderType, R2.Env == E, R2.Value: PrimitiveSequenceType, R2.Value.Trait == SingleTrait {
        return Reader.zipCommon(r1, r2)
            .map { (arg) -> Single<(R1.Value.Element, R2.Value.Element)> in
                let (s1, s2) = arg
                return Single.zip(s1.primitiveSequence, s2.primitiveSequence)
        }
}

public func batch<E, R1, R2, R3>(_ r1: R1, _ r2: R2, _ r3: R3) ->
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

public func batch<E, R1, R2, R3, R4>(_ r1: R1, _ r2: R2, _ r3: R3, _ r4: R4) ->
    Reader<E, Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element)>> where
    R1: ReaderType, R1.Env == E, R1.Value: PrimitiveSequenceType, R1.Value.Trait == SingleTrait,
    R2: ReaderType, R2.Env == E, R2.Value: PrimitiveSequenceType, R2.Value.Trait == SingleTrait,
    R3: ReaderType, R3.Env == E, R3.Value: PrimitiveSequenceType, R3.Value.Trait == SingleTrait,
    R4: ReaderType, R4.Env == E, R4.Value: PrimitiveSequenceType, R4.Value.Trait == SingleTrait {
        return Reader.zipCommon(r1, r2, r3, r4)
            .map { (arg) -> Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element)> in
                let (s1, s2, s3, s4) = arg
                return Single.zip(s1.primitiveSequence, s2.primitiveSequence, s3.primitiveSequence, s4.primitiveSequence)
        }
}

public func batch<E, R1, R2, R3, R4, R5>(_ r1: R1, _ r2: R2, _ r3: R3, _ r4: R4, _ r5: R5) ->
    Reader<E, Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element, R5.Value.Element)>> where
    R1: ReaderType, R1.Env == E, R1.Value: PrimitiveSequenceType, R1.Value.Trait == SingleTrait,
    R2: ReaderType, R2.Env == E, R2.Value: PrimitiveSequenceType, R2.Value.Trait == SingleTrait,
    R3: ReaderType, R3.Env == E, R3.Value: PrimitiveSequenceType, R3.Value.Trait == SingleTrait,
    R4: ReaderType, R4.Env == E, R4.Value: PrimitiveSequenceType, R4.Value.Trait == SingleTrait,
    R5: ReaderType, R5.Env == E, R5.Value: PrimitiveSequenceType, R5.Value.Trait == SingleTrait {
        return Reader.zipCommon(r1, r2, r3, r4, r5)
            .map { (arg) -> Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element, R5.Value.Element)> in
                let (s1, s2, s3, s4, s5) = arg
                return Observable.zip(
                    s1.primitiveSequence.asObservable(),
                    s2.primitiveSequence.asObservable(),
                    s3.primitiveSequence.asObservable(),
                    s4.primitiveSequence.asObservable(),
                    s5.primitiveSequence.asObservable()
                    ).asSingle()
        }
}

public func batch<E, R1, R2, R3, R4, R5, R6>(_ r1: R1, _ r2: R2, _ r3: R3, _ r4: R4, _ r5: R5, _ r6: R6) ->
    Reader<E, Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element, R5.Value.Element, R6.Value.Element)>> where
    R1: ReaderType, R1.Env == E, R1.Value: PrimitiveSequenceType, R1.Value.Trait == SingleTrait,
    R2: ReaderType, R2.Env == E, R2.Value: PrimitiveSequenceType, R2.Value.Trait == SingleTrait,
    R3: ReaderType, R3.Env == E, R3.Value: PrimitiveSequenceType, R3.Value.Trait == SingleTrait,
    R4: ReaderType, R4.Env == E, R4.Value: PrimitiveSequenceType, R4.Value.Trait == SingleTrait,
    R5: ReaderType, R5.Env == E, R5.Value: PrimitiveSequenceType, R5.Value.Trait == SingleTrait,
    R6: ReaderType, R6.Env == E, R6.Value: PrimitiveSequenceType, R6.Value.Trait == SingleTrait {
        return Reader.zipCommon(r1, r2, r3, r4, r5, r6)
            .map { (arg) -> Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element, R5.Value.Element, R6.Value.Element)> in
                let (s1, s2, s3, s4, s5, s6) = arg
                return Observable.zip(
                    s1.primitiveSequence.asObservable(),
                    s2.primitiveSequence.asObservable(),
                    s3.primitiveSequence.asObservable(),
                    s4.primitiveSequence.asObservable(),
                    s5.primitiveSequence.asObservable(),
                    s6.primitiveSequence.asObservable()
                    ).asSingle()
        }
}

public func batch<E, R1, R2, R3, R4, R5, R6, R7>(_ r1: R1, _ r2: R2, _ r3: R3, _ r4: R4, _ r5: R5, _ r6: R6, _ r7: R7) ->
    Reader<E, Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element, R5.Value.Element, R6.Value.Element, R7.Value.Element)>> where
    R1: ReaderType, R1.Env == E, R1.Value: PrimitiveSequenceType, R1.Value.Trait == SingleTrait,
    R2: ReaderType, R2.Env == E, R2.Value: PrimitiveSequenceType, R2.Value.Trait == SingleTrait,
    R3: ReaderType, R3.Env == E, R3.Value: PrimitiveSequenceType, R3.Value.Trait == SingleTrait,
    R4: ReaderType, R4.Env == E, R4.Value: PrimitiveSequenceType, R4.Value.Trait == SingleTrait,
    R5: ReaderType, R5.Env == E, R5.Value: PrimitiveSequenceType, R5.Value.Trait == SingleTrait,
    R6: ReaderType, R6.Env == E, R6.Value: PrimitiveSequenceType, R6.Value.Trait == SingleTrait,
    R7: ReaderType, R7.Env == E, R7.Value: PrimitiveSequenceType, R7.Value.Trait == SingleTrait {
        return Reader.zipCommon(r1, r2, r3, r4, r5, r6, r7)
            .map { (arg) -> Single<(R1.Value.Element, R2.Value.Element, R3.Value.Element, R4.Value.Element, R5.Value.Element, R6.Value.Element, R7.Value.Element)> in
                let (s1, s2, s3, s4, s5, s6, s7) = arg
                return Observable.zip(
                    s1.primitiveSequence.asObservable(),
                    s2.primitiveSequence.asObservable(),
                    s3.primitiveSequence.asObservable(),
                    s4.primitiveSequence.asObservable(),
                    s5.primitiveSequence.asObservable(),
                    s6.primitiveSequence.asObservable(),
                    s7.primitiveSequence.asObservable()
                    ).asSingle()
        }
}

public func batch<E, R>(_ readers: [R]) -> Reader<E, Single<[R.Value.Element]>> where
    R: ReaderType, R.Env == E, R.Value: PrimitiveSequenceType, R.Value.Trait == SingleTrait {
        return Reader.zipCommon(readers)
            .map { streams in Single.zip(streams.map { $0.primitiveSequence }) }
}

public func merge<E, R>(_ readers: [R]) -> Reader<E, Observable<R.Value.Element>> where
    R: ReaderType, R.Env == E, R.Value: ObservableType {
        return Reader.zipCommon(readers).map { xs in Observable.from(xs).merge() }
}

public func merge<E, R>(_ readers: R...) -> Reader<E, Observable<R.Value.Element>> where
    R: ReaderType, R.Env == E, R.Value: ObservableType {
        return Reader.zipCommon(readers).map { xs in Observable.from(xs).merge() }
}
