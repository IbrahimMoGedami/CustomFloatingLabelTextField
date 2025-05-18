//
//  ContentView.swift
//  FloatingBorderTextFieldExample
//
//  Created by Ibrahim Gedami on 26/04/2025.
//

import SwiftUI
import FloatingBorderTextField

struct ContentView: View {
    
    @State private var firstNameTextFiled: String = "12345"
    @State private var lastNameTextFiled: String = "12345"
    @State private var emailTextFiled: String = ""
    @State private var password: String = ""
    @State private var notes: String = ""
    @State private var country: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 50) {
                FloatingBorderTextField(title: "First Name", text: $firstNameTextFiled)
                    .validation(NameValidator())
                    .required(true)
                
                FloatingBorderTextField(title: "Last Name", text: $lastNameTextFiled)
                    .validation(NameValidator())
                    .required(false)
                
                FloatingBorderTextField(title: "Email", text: $emailTextFiled)
                    .validation(ValidationFactory.email)
                
                FloatingBorderTextField(
                    title: "Password",
                    text: $password,
                    isSecureField: true
                )
                .validation(MyPasswordValidator())
                
                FloatingBorderTextField(
                    title: "Country",
                    text: $country)
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
                
                FloatingBorderTextField(
                    title: "Notes",
                    text: $notes,
                    isMultiline: true
                )
            }
            .padding()
        }
    }
    
}

#Preview {
    ContentView()
}
