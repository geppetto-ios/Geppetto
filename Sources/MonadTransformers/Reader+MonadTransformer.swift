//
//  Reader+MonadTransformer.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift

public extension ReaderType where Value: ObservableType {
    func mapT<U>(_ f: @escaping (Value.Element) -> U) -> Reader<Env, Observable<U>> {
        return map { observable in observable.map(f) }
    }
}
