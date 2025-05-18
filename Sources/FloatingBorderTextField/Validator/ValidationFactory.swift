//
//  ValidationFactory.swift
//  NewLearnings
//
//  Created by Ibrahim Gedami on 03/05/2025.
//

import Foundation

public enum ValidationFactory {
    
    public static var email: TextFieldValidator {
        CompositeValidator([
            (NonEmptyValidator()),
            (EmailValidator())
        ])
    }
    
    public static var phone: TextFieldValidator {
        CompositeValidator([
            (NonEmptyValidator()),
            (NumericValidator())
        ])
    }
    
    public static var name: TextFieldValidator {
        CompositeValidator([
            (NonEmptyValidator()),
            (NameValidator())
        ])
    }
    
    public static var password: TextFieldValidator {
        CompositeValidator([
            (NonEmptyValidator()),
            (NameValidator())
        ])
    }
    
}
