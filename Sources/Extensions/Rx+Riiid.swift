////
////  RxCocoa+Riiid.swift
////  LifeIsShort
////
////  Created by jinseo on 2016. 9. 21..
////  Copyright © 2016년 Riiid. All rights reserved.
////
//
//import UIKit
//import RxCocoa
//import RxSwift
//
//extension Reactive where Base: UIResponder {
//    func becomeFirstResponder() -> Single<Bool> {
//        return Single<Bool>.create { single in single(.success(self.base.becomeFirstResponder()))
//            return Disposables.create()
//        }
//    }
//}
//
//extension ObservableType {
//    func bindDistinctly<O>(to observer: O) -> Disposable where O: ObserverType, O.Element == Self.Element, Self.Element: Equatable {
//        return distinctUntilChanged().bind(to: observer)
//    }
//
//    func bindDistinctly<O>(to observer: O) -> Disposable where O: ObserverType, O.Element == Self.Element?, Self.Element: Equatable {
//        return distinctUntilChanged().bind(to: observer)
//    }
//}
//
//extension ObservableType where Element: OptionalType, Element.Wrapped: Equatable {
//    public func distinctUntilChanged() -> Observable<Element> {
//        return self.distinctUntilChanged { (lhs, rhs) -> Bool in
//            return lhs.value == rhs.value
//        }
//    }
//}
//
//extension ObservableType where Element == Bool {
//    func negate() -> Observable<Element> {
//        return map { value -> Element in !value }
//    }
//}
//
//extension ObservableType {
//    /**
//     Pauses the elements of the source observable sequence based on the latest element from the second observable sequence.
//     Elements are ignored unless the second sequence has most recently emitted `true`.
//     - seealso: [pausable operator on reactivex.io](http://reactivex.io/documentation/operators/backpressure.html)
//     - parameter pauser: The observable sequence used to pause the source observable sequence.
//     - returns: The observable sequence which is paused based upon the pauser observable sequence.
//     */
//
//    func zipWithPrevious(initial: Element) -> Observable<(Element, Element)> {
//        return scan((initial, initial), accumulator: { ($0.1, $1) })
//
//    }
//
//    public func mapTo<T>(_ t: T) -> Observable<T> {
//        return map { _ in t }
//    }
//
//    public func pausable<P: ObservableType> (_ pauser: P) -> Observable<Element> where P.Element == Bool {
//        return withLatestFrom(pauser) { element, paused in
//            (element, paused)
//            }.filter { _, paused in
//                paused
//            }.map { element, _ in
//                element
//        }
//    }
//
//}
//
//extension Reactive where Base: UIButton {
//    func image(_ state: UIControl.State) -> AnyObserver<UIImage?> {
//        return Binder<UIImage?>(self.base) { button, image -> Void in
//            button.setImage(image, for: state)
//            }.asObserver()
//    }
//}
//
//extension Reactive where Base: UITextView {
//    var attributedText: AnyObserver<NSAttributedString?> {
//        return Binder<NSAttributedString?>(self.base) {
//            textView, attrText -> Void in
//            textView.attributedText = attrText
//        }.asObserver()
//    }
//}
//
//extension Reactive where Base: UIView {
//    var backgroundColor: AnyObserver<UIColor?> {
//        return Binder<UIColor?>(self.base) { view, color -> Void in
//            view.backgroundColor = color
//        }.asObserver()
//    }
//
//    var tintColor: AnyObserver<UIColor> {
//        return Binder<UIColor>(self.base) { (view: UIView, color: UIColor) -> Void in
//            view.tintColor = color
//        }.asObserver()
//    }
//
//    var isUserInteractionEnabled: AnyObserver<Bool> {
//        return Binder<Bool>(self.base) { view, flag -> Void in
//            view.isUserInteractionEnabled = flag
//            }.asObserver()
//    }
//}
//
//extension Reactive where Base: UILabel {
//    var textColor: AnyObserver<UIColor> {
//        return Binder<UIColor>(self.base) { label, color -> Void in
//            label.textColor = color
//        }.asObserver()
//    }
//}
//
//extension Reactive where Base: UIGestureRecognizer {
//    var isEnabled: AnyObserver<Bool> {
//        return Binder<Bool>(self.base) { gestureRecognizer, isEnabled -> Void in
//            gestureRecognizer.isEnabled = isEnabled
//        }.asObserver()
//    }
//}
//
//extension RxSwift.PrimitiveSequenceType where Trait == RxSwift.SingleTrait, Element: ResultType {
//    func flatMapT<U>(_ f: @escaping (Element.Success) -> Single<Result<U, Element.Failure>>) -> Single<Result<U, Element.Failure>> {
//        return flatMap { result -> Single<Result<U, Element.Failure>> in
//            return result.fold(f, Result<U, Element.Failure>.failure >>> Single.just)
//        }
//    }
//}
//
//extension RxSwift.PrimitiveSequenceType where Trait == RxSwift.SingleTrait, Element: ResultType, Element.Success: OptionalType, Element.Failure == SantaError {
//    func flatMapTT<U>(_ f: @escaping (Element.Success.Wrapped) -> Single<Result<U, Element.Failure>>) -> Single<Result<U, Element.Failure>> {
//        return flatMapT { optional -> Single<Result<U, ElementType.Failure>> in
//            return optional.fold(
//                onSome: f,
//                onNone: Single<Result<U, ElementType.Failure>>.just(.failure(SantaError.optionalError("")))
//            )
//        }
//    }
//}
