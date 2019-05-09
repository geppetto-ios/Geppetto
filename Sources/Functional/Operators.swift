//
//  Functional.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

precedencegroup ForwardComposition {
    associativity: left
}

infix operator >>>: ForwardComposition

public func >>> <T, U, V>(f: @escaping (T) -> U, g: @escaping (U) -> V) -> (T) -> V {
    return { x in g(f(x)) }
}

