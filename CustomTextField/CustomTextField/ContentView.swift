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
        case firstName, lastName, email, password, country, notes
    }
    
    @State private var firstNameTextFiled: String = "12345"
    @State private var lastNameTextFiled: String = "12345"
    @State private var emailTextFiled: String = ""
    @State private var password: String = ""
    @State private var notes: String = ""
    @State private var country: String = ""
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                FloatingLabelTextField(title: "First Name", text: $firstNameTextFiled)
                    .validation(ValidationFactory.name)
                    .required(true)
                    .returnKeyType(.next)
                    .onSubmit {
                        if firstNameTextFiled.isEmpty || NameValidator().validate(firstNameTextFiled) == nil {
                            focusedField = .lastName
                        }
                    }
                    .focused($focusedField, equals: .firstName)
                
                FloatingLabelTextField(title: "Last Name", text: $lastNameTextFiled)
                    .validation(ValidationFactory.name)
                    .required(false)
                    .returnKeyType(.next)
                    .onSubmit {
                        if lastNameTextFiled.isEmpty || NameValidator().validate(lastNameTextFiled) == nil {
                            focusedField = .email
                        }
                    }
                    .focused($focusedField, equals: .lastName)
                
                FloatingLabelTextField(title: "Email", text: $emailTextFiled)
                    .validation(ValidationFactory.email)
                    .returnKeyType(.next)
                    .onSubmit {
                        if emailTextFiled.isEmpty || EmailValidator().validate(emailTextFiled) == nil {
                            focusedField = .password
                        }
                    }
                    .focused($focusedField, equals: .email)
                
                FloatingLabelTextField(
                    title: "Password",
                    text: $password,
                    style: .secure
                )
                .validation(ValidationFactory.password)
                .returnKeyType(.next)
                .onSubmit {
                    if password.isEmpty || MyPasswordValidator().validate(password) == nil {
                        focusedField = .country
                    }
                }
                .focused($focusedField, equals: .password)
                
                FloatingLabelTextField(title: "Country", text: $country)
                    .textFieldEnabled(false)
                    .rightView {
                        Menu {
                            ForEach(["UAE", "Qatar", "Kuwait"], id: \.self) { item in
                                Button(item) { country = item }
                            }
                        } label: {
                            Image(systemName: "chevron.down")
                        }
                    }
                    .focused($focusedField, equals: .country)
                
                FloatingLabelTextField(title: "Notes", text: $notes, style: .multiline)
                    .focused($focusedField, equals: .notes)
            }
            .padding()
        }
        .onAppear {
            focusedField = .firstName
        }
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
