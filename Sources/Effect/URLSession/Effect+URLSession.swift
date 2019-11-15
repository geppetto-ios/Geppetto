//
//  Effect+URLSession.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 13/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public protocol HasURLSession {
    var urlSession: URLSession { get }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element: HasURLSession {
    var urlSession: Effect<Env, URLSession> {
        return mapT { $0.urlSession }
    }
}

public extension ReaderType where Value: PrimitiveSequenceType, Value.Trait == SingleTrait, Value.Element == URLSession {
    func data(request: URLRequest) -> Effect<Env, Data> {
        return flatMapT { (session: URLSession) -> Effect<Env, Data> in 
            Effect<Env, Data>(run: const(
                session.rx.data(request: request)
                    .observeOn(MainScheduler.instance)
                    .asSingle()
                )
            )
        }
    }
}
