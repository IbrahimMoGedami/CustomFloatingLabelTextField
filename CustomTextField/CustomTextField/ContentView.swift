//
//  ContentView.swift
//  CustomTextField
//
//  Created by Ibrahim Mo Gedami on 13/08/2025.
//

import SwiftUI
import FloatingBorderTextField

struct ContentView: View {
    enum Field: Hashable {
        case firstName, lastName, email, password, phone, notes
    }
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phone: String = ""
    @State private var notes: String = ""
    @State private var rememberMe: Bool = false
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Form title
                Text("Registration Form")
                    .font(.title)
                    .padding(.bottom, 20)
                
                // First Name
                FloatingLabelTextField(title: "First Name", text: $firstName, style: .normal)
                    .validation(ValidationFactory.name())
                    .required(true)
                    .returnKeyType(.next)
                    .onSubmit { focusedField = .lastName }
                    .leftView {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                    }
                    .focused($focusedField, equals: .firstName)
                    .autocapitalization(.words)
                
                // Last Name
                FloatingLabelTextField(title: "Last Name", text: $lastName, style: .normal)
                    .validation(ValidationFactory.name())
                    .returnKeyType(.next)
                    .onSubmit { focusedField = .email }
                    .focused($focusedField, equals: .lastName)
                    .autocapitalization(.words)
                
                // Email
                FloatingLabelTextField(title: "Email", text: $email, style: .email)
                    .validation(ValidationFactory.email())
                    .required(true)
                    .returnKeyType(.next)
                    .onSubmit { focusedField = .phone }
                    .leftView {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                    }
                    .focused($focusedField, equals: .email)
                
                // Phone
                FloatingLabelTextField(title: "Phone", text: $phone, style: .phone)
                    .validation(ValidationFactory.phone())
                    .returnKeyType(.next)
                    .onSubmit { focusedField = .password }
                    .leftView {
                        Image(systemName: "phone")
                            .foregroundColor(.gray)
                    }
                    .characterLimit(15, showCount: true)
                    .focused($focusedField, equals: .phone)
                
                // Password
                FloatingLabelTextField(title: "Password", text: $password, style: .secure)
                    .validation(ValidationFactory.password())
                    .required(true)
                    .returnKeyType(.done)
                    .onSubmit { focusedField = nil }
                    .leftView {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                    }
                    .focused($focusedField, equals: .password)
                
                // Notes (multiline)
                FloatingLabelTextField(title: "Notes", text: $notes, style: .multiline)
                    .characterLimit(200, showCount: true)
                    .frame(height: 100)
                
                // Remember Me toggle
                Toggle("Remember Me", isOn: $rememberMe)
                    .padding(.vertical)
                
                // Submit Button
                Button(action: submitForm) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .onAppear {
            focusedField = .firstName
        }
    }
    
    private func submitForm() {
        // Handle form submission
        print("Form submitted")
    }
    
}

#Preview {
    ContentView()
}

extension View {
    
    func isEnabled(_ isEnabled: Bool) -> some View {
        self.modifier(EnableFieldModifier(isEnabled: isEnabled))
    }
}

struct EnableFieldModifier: ViewModifier {
    
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .disabled(!isEnabled)
            .opacity(isEnabled ? 1 : 0.5)
    }
    
}
