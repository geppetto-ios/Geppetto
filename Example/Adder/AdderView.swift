//
//  AdderView.swift
//  Example
//
//  Created by JinSeo Yoon on 18/11/2019.
//  Copyright © 2019 rinndash. All rights reserved.
//

import Foundation
import RxSwift
import Geppetto
import SnapKit

protocol AdderViewModel {
    associatedtype Message
    
    var resultText: String? { get }
    var isLoading: Bool { get }
    
    func onUpdateLeftTextField(value: String?) -> Message
    func onUpdateRightTextField(value: String?) -> Message
}

class AdderView<Model, Message>: View<Model, Message> where Model: AdderViewModel, Model.Message == Message {
    private let leftOperandTextField: UITextField = UITextField() 
    private let rightOperandTextField: UITextField = UITextField()
    private let resultLabel: UILabel = UILabel()
    private let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(leftOperandTextField)
        addSubview(rightOperandTextField)
        addSubview(resultLabel)
        addSubview(loadingIndicator)
    }
    
    override func layout() {
        super.layout()
        
        let plusLabel: UILabel = UILabel()
        plusLabel.text = "+"
        
        let equalsLabel: UILabel = UILabel()
        equalsLabel.text = "="
        
        let stackView = UIStackView(arrangedSubviews: [
            leftOperandTextField,
            plusLabel,
            rightOperandTextField,
            equalsLabel,
            resultLabel
        ])
        
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        leftOperandTextField.snp.makeConstraints { $0.width.equalTo(rightOperandTextField) }
        leftOperandTextField.snp.makeConstraints { $0.width.equalTo(resultLabel) }
        loadingIndicator.snp.makeConstraints { $0.center.equalTo(resultLabel) }
    }
    
    override func style() {
        super.style()
        loadingIndicator.hidesWhenStopped = true
    }
    
    override func behavior() {
        super.behavior()
        
        let updateLeftOperand$: Observable<Message> = leftOperandTextField.rx.value
            .distinctUntilChanged()
            .withLatestFrom(rx.updated.map { $0.onUpdateLeftTextField }) { x, f in f(x) }
            
        let updateRightOperand$: Observable<Message> = rightOperandTextField.rx.value
            .withLatestFrom(rx.updated.map { $0.onUpdateRightTextField }) { x, f in f(x) }
            
        let input$ = Observable.merge(updateLeftOperand$, updateRightOperand$)            
        
        input$
            .bind(to: rx.dispatch)
            .disposed(by: disposeBag)
        
        rx.updated
            .map { $0.resultText }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        rx.updated
            .map { $0.isLoading }
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
