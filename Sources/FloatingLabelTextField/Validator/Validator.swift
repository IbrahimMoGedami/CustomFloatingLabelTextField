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
    private let message: String
    
    public init(message: String = "This field is required.") {
        self.message = message
    }
    
    public func validate(_ text: String) -> String? {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? message : nil
    }
}

public struct EmailValidator: TextFieldValidator {
    private let message: String
    
    public init(message: String = "Invalid email address.") {
        self.message = message
    }
    
    public func validate(_ text: String) -> String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: text) ? nil : message
    }
}

public struct NumericValidator: TextFieldValidator {
    private let message: String
    
    public init(message: String = "Only numbers allowed.") {
        self.message = message
    }
    
    public func validate(_ text: String) -> String? {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: text))
        ? nil : message
    }
}

public struct PhoneValidator: TextFieldValidator {
    private let message: String
    
    public init(message: String = "Invalid phone number.") {
        self.message = message
    }
    
    public func validate(_ text: String) -> String? {
        let phoneRegEx = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: text) ? nil : message
    }
}

public struct NameValidator: TextFieldValidator {
    private let message: String
    private let minLength: Int
    
    public init(message: String = "Name must be at least 2 characters and contain no numbers.", minLength: Int = 2) {
        self.message = message
        self.minLength = minLength
    }
    
    public func validate(_ text: String) -> String? {
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Name is required."
        }
        
        let containsNumbers = text.rangeOfCharacter(from: .decimalDigits) != nil
        if containsNumbers {
            return "Name cannot contain numbers."
        }
        
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count < minLength {
            return "Name must be at least \(minLength) characters."
        }
        
        return nil
    }
}

public struct PasswordValidator: TextFieldValidator {
    private let minLength: Int
    private let requireUppercase: Bool
    private let requireSpecialCharacter: Bool
    private let requireDigit: Bool
    private let message: String
    
    public init(minLength: Int = 8,
                requireUppercase: Bool = true,
                requireSpecialCharacter: Bool = true,
                requireDigit: Bool = true,
                message: String = "Password must meet the requirements.") {
        self.minLength = minLength
        self.requireUppercase = requireUppercase
        self.requireSpecialCharacter = requireSpecialCharacter
        self.requireDigit = requireDigit
        self.message = message
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
