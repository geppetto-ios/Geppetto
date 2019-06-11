//
//  ViewController.swift
//  LifeIsShort
//
//  Created by jinseo on 2016. 8. 26..
//  Copyright © 2016년 Riiid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController2<Model, Event>: UIViewController, View2Type {
    let viewModel$: BehaviorRelay<Model?> = BehaviorRelay(value: nil)
    let event$: PublishSubject<Event> = PublishSubject()
    let disposeBag: DisposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {}
    
    func setupView() {
        addSubviews()
        layout()
        style()
        behavior()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func addSubviews() {
    }
    
    func layout() {
    }
    
    func style() {
    }
    
    func behavior() {
    }
}

class ViewController<Model>: ViewController2<Model, Void> { }
