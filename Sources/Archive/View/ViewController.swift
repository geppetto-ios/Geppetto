//
//  ViewController.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import RxSwift

open class ViewController<P: Program>: UIViewController, View {
    public let model$: ReplaySubject<P.Model> = ReplaySubject.create(bufferSize: 1)
    public let message$: PublishSubject<P.Message> = PublishSubject()
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
