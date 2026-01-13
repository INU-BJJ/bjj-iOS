//
//  BaseViewModel.swift
//  BJJ_iOS
//
//  Created by HyoTaek on 1/13/26.
//

protocol BaseViewModel {
    
    // MARK: - Input, Output
    
    associatedtype Input
    associatedtype Output
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output
}
