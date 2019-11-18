//
//  View.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import RxSwift

public protocol ViewType {
    associatedtype Model
    associatedtype Message
    
    var model$: PublishSubject<Model> { get }
    var message$: PublishSubject<Message> { get }
    
    var didReady$: Single<Void> { get }  
    
    var disposeBag: DisposeBag { get }
}

public extension ViewType {
    func run(_ model: Model) -> Observable<Message> {
        model$.onNext(model)
        return message$
    }
}

public extension Reactive where Base: ViewType {
    var updated: Observable<Base.Model> {
        return base.model$.asObservable()
    }
    
    var update: AnyObserver<Base.Model> {
        return base.model$.asObserver()
    }
    
    var message: Observable<Base.Message> {
        return base.message$.asObservable()
    }
    
    var dispatch: AnyObserver<Base.Message> {
        return base.message$.asObserver()
    }
}
