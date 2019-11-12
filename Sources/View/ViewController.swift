//
//  ViewController.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ViewController<P: Program>: UIViewController, View {
    public let model$: PublishSubject<P.Model> = PublishSubject()
    public let message$: PublishSubject<P.Message> = PublishSubject()
    
    public var didReady$: Single<Void> { return rx.viewWillAppear.take(1).mapTo(()).asSingle() }
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
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

public extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}
