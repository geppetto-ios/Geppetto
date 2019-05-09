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
}
