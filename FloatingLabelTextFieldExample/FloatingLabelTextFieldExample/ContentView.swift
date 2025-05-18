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
                FloatingLabelTextField(title: "First Name", text: $firstNameTextFiled)
                    .validation(NameValidator())
                    .required(true)
                
                FloatingLabelTextField(title: "Last Name", text: $lastNameTextFiled)
                    .validation(NameValidator())
                    .required(false)
                
                FloatingLabelTextField(title: "Email", text: $emailTextFiled)
                    .validation(ValidationFactory.email)
                
                FloatingLabelTextField(
                    title: "Password",
                    text: $password,
                    style: .secure
                )
                .validation(MyPasswordValidator())
                
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
                
                FloatingLabelTextField(title: "Notes", text: $notes, style: .multiline)
            }
            .padding()
        }
    }
    
}

#Preview {
    ContentView()
}
