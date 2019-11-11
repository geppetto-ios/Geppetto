//
//  Command+MonadTransformer.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift

public extension ReaderType where Value: ObservableConvertibleType {
    func mapT<U>(_ f: @escaping (Value.Element) -> U) -> Reader<Env, Observable<U>> {
        return map { x in x.asObservable().map(f) }
    }
}

public extension ReaderType where Value: ObservableType, Value.Element: OptionalType {
    static var none: Reader<Env, Observable<Value.Element.Wrapped?>> { return Reader<Env, Observable<Value.Element.Wrapped?>> { _ in Observable.just(nil) } }
}
