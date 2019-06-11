//
//  View.swift
//  LifeIsShort
//
//  Created by jinseo on 2017. 2. 20..
//  Copyright © 2017년 Riiid. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol View2Type: class {
    associatedtype Model        // Model
    associatedtype View2Event   // Message

    var viewModel$: BehaviorRelay<Model?> { get }
    var event$: PublishSubject<View2Event> { get }
}

extension View2Type {
    var viewModel: Model? {
        get { return viewModel$.value }
        set(value) { viewModel$.accept(value) }
    }

    static func update(with model: Model) -> (UIView) -> Observable<View2Event> {
        return { (view: UIView) -> Observable<View2Event> in
            guard let v = view as? Self else { return Observable.empty() }
            v.viewModel = model
            return v.event$.asObservable()
        }
    }
}

extension Reactive where Base: View2Type {
    var update: AnyObserver<Base.Model?> {

        return Binder<Base.Model?>(base) { view, vm in
            view.viewModel = vm
        }.asObserver()
    }

    var updated: Observable<Base.Model> {
        return base.viewModel$.asObservable()
            .filterNil()
            .takeUntil(deallocated)
            .share(replay: 1, scope: .forever)
    }

    var viewModel: Observable<Base.Model?> {
        return base.viewModel$.asObservable()
            .takeUntil(deallocated)
            .share(replay: 1, scope: .forever)
    }

    var event: Observable<Base.View2Event> {
        return base.event$
            .takeUntil(deallocated)
    }

    var dispatch: AnyObserver<Base.View2Event> {
        return base.event$.asObserver()
    }
}

extension View2Type {
    func bind(model: Model) -> Observable<View2Event> {
        self.viewModel = model
        return event$
    }
}

class View2<Model, Event>: UIView, View2Type {
    let viewModel$: BehaviorRelay<Model?> = BehaviorRelay(value: nil)
    let event$: PublishSubject<Event> = PublishSubject()
    let disposeBag: DisposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        addSubviews()
        layout()
        style()
        behavior()
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

class TableViewCell2<Model, Event>: UITableViewCell, View2Type {
    let viewModel$: BehaviorRelay<Model?> = BehaviorRelay(value: nil)
    let event$: PublishSubject<Event> = PublishSubject()
    let disposeBag: DisposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        addSubviews()
        layout()
        style()
        behavior()
    }

    func addSubviews() {

    }

    func layout() {

    }

    func style() {
        selectionStyle = .none
    }

    func behavior() {

    }
}

class View<Model>: View2<Model, Void> {}
class TableViewCell<Model>: TableViewCell2<Model, Void> {}
