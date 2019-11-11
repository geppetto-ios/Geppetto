//
//  OptionalType.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
    func fold<T>(onSome f: @escaping (Wrapped) -> T, onNone g: @autoclosure () -> T) -> T
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        switch self {
        case let .some(x):
            return x
        case .none:
            return nil
        }
    }
    
    public func fold<T>(onSome f: @escaping (Wrapped) -> T, onNone g: @autoclosure () -> T) -> T {
        switch self {
        case let .some(x): return f(x)
        case .none: return g()
        }
    }
}
