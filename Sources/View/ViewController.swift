//
//  ViewController.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import UIKit
import RxSwift

public class ViewController<P: Program>: UIViewController, View {
    public let model$: ReplaySubject<P.Model> = ReplaySubject.create(bufferSize: 1)
    public let message$: PublishSubject<P.Message> = PublishSubject()
    public let disposeBag: DisposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        style()
        behavior()
    }
    
    public func addSubviews() {
        
    }
    
    public func layout() {
        
    }
    
    public func style() {
        
    }
    
    public func behavior() {
        
    }
}
