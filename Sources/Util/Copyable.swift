//
//  Copyable.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

public protocol Copyable {
    func copy(with transform: (inout Self) -> Void) -> Self
}

public extension Copyable {
    func copy(with transform: (inout Self) -> Void) -> Self {
        var copy = self
        transform(&copy)
        return copy
    }
}
