//
//  View.swift
//  Example
//
//  Created by JinSeo Yoon on 18/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class View<Model, Message>: UIView, ViewType {
    public let model$: PublishSubject<Model> = PublishSubject()
    public let message$: PublishSubject<Message> = PublishSubject()
    
    public var didReady$: Single<Void> { return Single.just(()) }
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        addSubviews()
        layout()
        style()
        behavior()
    }
    
    open func addSubviews() {
        
    }
    
    open func layout() {
        
    }
    
    open func style() {
        
    }
    
    open func behavior() {
        
    }
}

public extension Reactive where Base: UIView {
    
}
