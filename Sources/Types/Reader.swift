//
//  ReaderType.swift
//  Geppetto
//
//  Created by JinSeo Yoon on 09/05/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

public protocol ReaderType {
    associatedtype Env
    associatedtype Value
    var run: (Env) -> Value { get }
}

public extension ReaderType {
    static func pure(_ a: Value) -> Reader<Env, Value> {
        return Reader<Env, Value> { _ in a }
    }
    
    func flatMap<U>(_ f: @escaping (Value) -> Reader<Env, U>) -> Reader<Env, U> {
        return Reader<Env, U> { i in f(self.run(i)).run(i) }
    }
}

public extension ReaderType {
    func dimap<F, U>(from: @escaping (F) -> Env, to: @escaping (Value) -> U) -> Reader<F, U> {
        return Reader<F, U>.init(run: from >>> self.run >>> to)
    }
    
    func contraMap<F>(_ f: @escaping (F) -> Env) -> Reader<F, Value> {
        return dimap(from: f, to: id)
    }
    
    func map<U>(_ f: @escaping (Value) -> U) -> Reader<Env, U> {
        return dimap(from: id, to: f)
    }
}

public struct Reader<Environment, Value>: ReaderType {
    public let run: (Environment) -> Value
    
    public init(run: @escaping (Environment) -> Value) {
        self.run = run
    }
}

public extension ReaderType {
    static func zip<R1, R2>(_ first: R1, _ second: R2) -> Reader<(R1.Env, R2.Env), (R1.Value, R2.Value)> where R1: ReaderType, R2: ReaderType, Env == (R1.Env, R2.Env), Value == (R1.Value, R2.Value) {
        return Reader<(R1.Env, R2.Env), (R1.Value, R2.Value)>.init(run: { e1, e2 in (first.run(e1), second.run(e2)) })
    }
    
    static func zipCommon<R>(_ readers: [R]) -> Reader<Env, [R.Value]> where R: ReaderType, R.Env == Env, Value == R.Value {
        return Reader<Env, [R.Value]>.init(run: { e in readers.map { $0.run(e) } })
    }
    
    static func zipCommon<R1, R2>(_ first: R1, _ second: R2) -> Reader<Env, (R1.Value, R2.Value)> where R1: ReaderType, R2: ReaderType, R1.Env == Env, R2.Env == Env, Value == (R1.Value, R2.Value) {
        return Reader<Env, (R1.Value, R2.Value)>.init(run: { e in (first.run(e), second.run(e)) })
    }
    
    static func zipCommon<R1, R2, R3>(_ first: R1, _ second: R2, _ third: R3) -> Reader<Env, (R1.Value, R2.Value, R3.Value)> where R1: ReaderType, R2: ReaderType, R3: ReaderType, R1.Env == Env, R2.Env == Env, R3.Env == Env, Value == (R1.Value, R2.Value, R3.Value) {
        return Reader<Env, (R1.Value, R2.Value, R3.Value)>.init(run: { e in (first.run(e), second.run(e), third.run(e)) })
    }
    
    static func zipCommon<R1, R2, R3, R4>(_ first: R1, _ second: R2, _ third: R3, _ fourth: R4) -> Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value)> where R1: ReaderType, R2: ReaderType, R3: ReaderType, R4: ReaderType, R1.Env == Env, R2.Env == Env, R3.Env == Env, R4.Env == Env, Value == (R1.Value, R2.Value, R3.Value, R4.Value) {
        return Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value)>.init(run: { e in (first.run(e), second.run(e), third.run(e), fourth.run(e)) })
    }
    
    static func zipCommon<R1, R2, R3, R4, R5>(_ first: R1, _ second: R2, _ third: R3, _ fourth: R4, _ fifth: R5) -> Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value)> where R1: ReaderType, R2: ReaderType, R3: ReaderType, R4: ReaderType, R5: ReaderType, R1.Env == Env, R2.Env == Env, R3.Env == Env, R4.Env == Env, R5.Env == Env, Value == (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value) {
        return Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value)>.init(run: { e in (first.run(e), second.run(e), third.run(e), fourth.run(e), fifth.run(e)) })
    }
    
    static func zipCommon<R1, R2, R3, R4, R5, R6>(_ first: R1, _ second: R2, _ third: R3, _ fourth: R4, _ fifth: R5, _ sixth: R6) -> Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value)> where R1: ReaderType, R2: ReaderType, R3: ReaderType, R4: ReaderType, R5: ReaderType, R6: ReaderType, R1.Env == Env, R2.Env == Env, R3.Env == Env, R4.Env == Env, R5.Env == Env, R6.Env == Env, Value == (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value) {
        return Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value)>.init(run: { e in (first.run(e), second.run(e), third.run(e), fourth.run(e), fifth.run(e), sixth.run(e)) })
    }
    
    static func zipCommon<R1, R2, R3, R4, R5, R6, R7>(_ first: R1, _ second: R2, _ third: R3, _ fourth: R4, _ fifth: R5, _ sixth: R6, _ seventh: R7) -> Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value, R7.Value)> where R1: ReaderType, R2: ReaderType, R3: ReaderType, R4: ReaderType, R5: ReaderType, R6: ReaderType, R7: ReaderType, R1.Env == Env, R2.Env == Env, R3.Env == Env, R4.Env == Env, R5.Env == Env, R6.Env == Env, R7.Env == Env, Value == (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value, R7.Value) {
        return Reader<Env, (R1.Value, R2.Value, R3.Value, R4.Value, R5.Value, R6.Value, R7.Value)>.init(run: { e in (first.run(e), second.run(e), third.run(e), fourth.run(e), fifth.run(e), sixth.run(e), seventh.run(e)) })
    }
}
