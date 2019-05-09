//
//  EnvironmentType.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift
import RxSwiftExt

public protocol EnvironmentType {
    
}

public extension EnvironmentType {
    func run<Message>(_ command: Reader<Self, Observable<Message?>>) -> Observable<Message> {
        return command.run(self)
            .materialize()
            .flatMap { event -> Observable<Message?> in
                switch event {
                case let .next(message):
                    return Observable.just(message)
                case .error:
                    return Observable.empty()
                default:
                    return Observable.empty()
                }
            }
            .unwrap()
    }
}

