//
//  Validator.swift
//  NewLearnings
//
//  Created by Ibrahim Gedami on 03/05/2025.
//

import Foundation

public protocol TextFieldValidator {
    
    func validate(_ text: String) -> String?
    
}

public struct NonEmptyValidator: TextFieldValidator {
    
    public init() {}
    
    public func validate(_ text: String) -> String? {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "This field is required." : nil
    }
    
}

public struct EmailValidator: TextFieldValidator {
    
    public init() {}
    
    public func validate(_ text: String) -> String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: text) ? nil : "Invalid email address."
    }
    
}

public struct NumericValidator: TextFieldValidator {
    
    public init() {}
    
    public func validate(_ text: String) -> String? {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text))
        ? nil : "Only numbers allowed."
    }

}

public struct NameValidator: TextFieldValidator {
    
    public init() {}
    
    public func validate(_ text: String) -> String? {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Name is required."
        }
        
        let containsNumbers = text.rangeOfCharacter(from: .decimalDigits) != nil
        if containsNumbers {
            return "Name cannot contain numbers."
        }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
            return "Name must be at least 2 characters."
        }
        
        return nil
    }

}

public struct MyPasswordValidator: TextFieldValidator {
    
    private let minLength: Int
    private let requireUppercase: Bool
    private let requireSpecialCharacter: Bool
    private let requireDigit: Bool
    
    public init(minLength: Int = 8, requireUppercase: Bool = true, requireSpecialCharacter: Bool = true, requireDigit: Bool = true) {
        self.minLength = minLength
        self.requireUppercase = requireUppercase
        self.requireSpecialCharacter = requireSpecialCharacter
        self.requireDigit = requireDigit
    }
    
    public func validate(_ text: String) -> String? {
        if text.count < minLength {
            return "Password must be at least \(minLength) characters long."
        }
        
        if requireUppercase && !text.contains(where: { $0.isUppercase }) {
            return "Password must contain at least one uppercase letter."
        }
        
        if requireDigit && !text.contains(where: { $0.isNumber }) {
            return "Password must contain at least one digit."
        }
        
        if requireSpecialCharacter && !text.contains(where: { "!@#$%^&*()_+[]{}|;:,.<>?".contains($0) }) {
            return "Password must contain at least one special character."
        }
        
        return nil
    }

}
