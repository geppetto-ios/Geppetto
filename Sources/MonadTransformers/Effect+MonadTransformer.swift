//
//  Effect+MonadTransformer.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 11/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait {
    func mapT<U>(_ f: @escaping (Value.Element) -> U) -> Reader<Env, Single<U>> {
        return map { single in single.primitiveSequence.map(f) }
    }
    
    func flatMapT<U>(_ transform: @escaping (Value.Element) -> Reader<Env, Single<U>>) -> Reader<Env, Single<U>> {
        return Reader<Env, Single<U>> { config in
            self.run(config).flatMap { transform($0).run(config) }
        }
    }
}

