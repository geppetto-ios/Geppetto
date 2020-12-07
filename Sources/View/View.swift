//
//  View.swift
//  Geppetto
//
//  Created by 윤진서 on 2020/12/07.
//  Copyright © 2020 rinndash. All rights reserved.
//

import UIKit
import RxSwift

open class View<Model, Message>: UIView, ViewType {
    public let model$: PublishSubject<Model> = PublishSubject()
    public let message$: PublishSubject<Message> = PublishSubject()
    
    public let disposeBag: DisposeBag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
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
