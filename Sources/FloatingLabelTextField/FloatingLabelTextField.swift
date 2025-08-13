// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public enum FieldStyle {
    
    case normal
    case secure
    case multiline
    
}

public struct FloatingLabelTextField: View {
    
    let title: String
    @Binding var text: String
    
    @State private var validator: TextFieldValidator?
    @State private var errorMessage: String?
    @FocusState private var isTyping: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private var isTextFieldEnabled: Bool = true
    private var isRequired: Bool = false
    @State private var isSecure: Bool = true
    private let style: FieldStyle
    private var returnKeyType: UIReturnKeyType = .default
    private var onSubmit: (() -> Void)?
    
    @State private var rightView: AnyView?
    private var mainColor: Color = Color(hexString: "#1E4D80")
    
    public init(title: String,
                text: Binding<String>,
                style: FieldStyle = .normal,
                isTextFieldEnabled: Bool = true,
                defaultColor: Color = Color(hexString: "#1E4D80")) {
        self.title = title
        self._text = text
        self.style = style
        self.isTextFieldEnabled = isTextFieldEnabled
        self.mainColor = defaultColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    inputField
                        .padding(.leading, 12)
                        .frame(minHeight: 40)
                        .focused($isTyping)
                        .disabled(!isEnabled)
                        .disabled(!isTextFieldEnabled)
                        .submitLabel(returnKeyType == .next ? .next : .return)
                        .onSubmit {
                            if errorMessage == nil {
                                onSubmit?()
                            }
                        }
                    
                    Spacer(minLength: 0)
                    
                    if style == .secure {
                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundStyle(.gray)
                        }
                        .padding(.trailing, 12)
                    } else if let rightView = rightView {
                        rightView
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isTyping ? mainColor : (errorMessage == nil ? .gray : .red), lineWidth: 1)
                        .background(isEnabled ? .white : .gray.opacity(0.05))
                )
                .overlay(
                    Text(title)
                        .font(isTyping ? .title3 : .caption)
                        .padding(.horizontal, 5)
                        .background(.white)
                        .foregroundStyle(isTyping ? mainColor : (errorMessage == nil ? .gray : .red))
                        .scaleEffect(isTyping || !text.isEmpty ? 0.85 : 1.0, anchor: .leading)
                        .offset(y: isTyping || !text.isEmpty ? -11 : 15)
                        .padding(.leading, 18)
                        .onTapGesture {
                            isTyping = true
                        }
                        .animation(.linear(duration: 0.1), value: isTyping || !text.isEmpty),
                    alignment: .topLeading
                )
                
                if isRequired {
                    Text("*")
                        .foregroundStyle(.red)
                        .padding(.leading, -10)
                        .padding(.top, -10)
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.leading, 8)
            }
        }
        .onAppear {
            if !text.isEmpty || isTyping {
                validate()
            }
        }
        .onChange(of: text) { _, _ in
            isTyping = true
            if !text.isEmpty || isTyping {
                validate()
            }
        }
        .onChange(of: isTyping) { _, newValue in
            if newValue || !text.isEmpty {
                validate()
            }
        }
    }
        
    @ViewBuilder
    private var inputField: some View {
        if style == .multiline {
            TextEditor(text: $text)
                .background(Color.clear)
                .frame(maxHeight: .infinity)
                .scrollContentBackground(.hidden)
        } else if style == .secure && isSecure {
            SecureField("", text: $text)
        } else if style == .normal {
            TextField("", text: $text)
        }
    }
    
    private func validate() {
        if isRequired && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "\(title) is required"
            return
        }
        
        if let validator = validator {
            errorMessage = validator.validate(text)
        } else {
            errorMessage = nil
        }
    }
    
}

public extension FloatingLabelTextField {
    
    func validation(_ validator: TextFieldValidator) -> FloatingLabelTextField {
        var view = self
        view._validator = State(initialValue: validator)
        return view
    }
    
    func required(_ value: Bool) -> FloatingLabelTextField {
        var view = self
        view.isRequired = value
        return view
    }
    
    func rightView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> some View {
        var view = self
        view._rightView = State(initialValue: AnyView(content()))
        return view
    }
    
    func textFieldEnabled(_ isEnabled: Bool) -> FloatingLabelTextField {
        var view = self
        view.isTextFieldEnabled = isEnabled
        return view
    }
    
    func returnKeyType(_ type: UIReturnKeyType) -> FloatingLabelTextField {
        var view = self
        view.returnKeyType = type
        return view
    }
    
    func onSubmit(_ action: @escaping () -> Void) -> FloatingLabelTextField {
        var view = self
        view.onSubmit = action
        return view
    }
    
}

public extension View {
    
    func isEnabled(_ isEnabled: Bool) -> some View {
        self.modifier(EnableFieldModifier(isEnabled: isEnabled))
    }
    
}
