//
//  ValidationFactory.swift
//  NewLearnings
//
//  Created by Ibrahim Gedami on 03/05/2025.
//

import Foundation

public struct ValidationFactory {
    
    public static func nonEmpty(message: String = "This field is required.") -> NonEmptyValidator {
        NonEmptyValidator(message: message)
    }
    
    public static func email(message: String = "Invalid email address.") -> EmailValidator {
        EmailValidator(message: message)
    }
    
    public static func numeric(message: String = "Only numbers allowed.") -> NumericValidator {
        NumericValidator(message: message)
    }
    
    public static func phone(message: String = "Invalid phone number.") -> PhoneValidator {
        PhoneValidator(message: message)
    }
    
    public static func name(message: String = "Invalid name.", minLength: Int = 2) -> NameValidator {
        NameValidator(message: message, minLength: minLength)
    }
    
    public static func password(minLength: Int = 8,
                                requireUppercase: Bool = true,
                                requireSpecialCharacter: Bool = true,
                                requireDigit: Bool = true,
                                message: String = "Password must meet the requirements.") -> PasswordValidator {
        PasswordValidator(minLength: minLength,
                         requireUppercase: requireUppercase,
                         requireSpecialCharacter: requireSpecialCharacter,
                         requireDigit: requireDigit,
                         message: message)
    }
    
    public static func regex(regex: String, message: String) -> RegexValidator {
        RegexValidator(regex: regex, message: message)
    }
}

public struct RegexValidator: TextFieldValidator {
    private let regex: String
    private let message: String
    
    public init(regex: String, message: String) {
        self.regex = regex
        self.message = message
    }
    
    public func validate(_ text: String) -> String? {
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: text) ? nil : message
    }
}
