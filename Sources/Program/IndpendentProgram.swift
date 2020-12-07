//
//  IndpendentProgram.swift
//  Geppetto
//
//  Created by 윤진서 on 2020/12/07.
//  Copyright © 2020 rinndash. All rights reserved.
//

import Foundation
import RxSwift

public protocol IndependentProgram: Program where Dependency == Unit {
    static var initialModel: Model { get }
    static var initialCommand: Command { get }
}

public extension IndependentProgram {
    static func initialModel(_ dependency: Dependency) -> Model { initialModel }
    static func initialCommand(_ dependency: Dependency) -> Command { initialCommand }
}

public extension IndependentProgram {
    static func bind<V>(with view: V, environment: Environment) where V: ViewController<Self> {
        bind(with: view, dependency: Unit(), environment: environment)
    }
}
