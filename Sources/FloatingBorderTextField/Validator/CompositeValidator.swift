//
//  CompositeValidator.swift
//  NewLearnings
//
//  Created by Ibrahim Gedami on 03/05/2025.
//

import Foundation

public struct CompositeValidator: TextFieldValidator {
    
    private let rules: [(TextFieldValidator)]
    
    public init(_ rules: [(TextFieldValidator)]) {
        self.rules = rules
    }
    
    public func validate(_ text: String) -> String? {
        for (validator) in rules {
            if let error = validator.validate(text) {
                return error
            }
        }
        return nil
    }
    
}
