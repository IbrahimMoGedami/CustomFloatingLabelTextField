// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public enum FieldStyle {
    
    case normal
    case secure
    case multiline
    case numeric
    case phone
    case email
    
}

public enum ValidationState: Equatable {
    case none
    case valid
    case error(String)
}

public struct FloatingLabelTextField: View {
    // MARK: - Configuration
    let title: String
    @Binding var text: String
    
    // MARK: - State Properties
    @State private var validator: TextFieldValidator?
    @State private var validationState: ValidationState = .none
    @FocusState private var isTyping: Bool
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isSecure: Bool = true
    @State private var rightView: AnyView?
    @State private var leftView: AnyView?
    @State private var characterLimit: Int?
    @State private var showCharacterCount: Bool = false
    
    // MARK: - Customization Properties
    private var isTextFieldEnabled: Bool = true
    private var isRequired: Bool = false
    private let style: FieldStyle
    private var returnKeyType: UIReturnKeyType = .default
    private var onSubmit: (() -> Void)?
    private var onEditingChanged: ((Bool) -> Void)?
    private var onCommit: (() -> Void)?
    private var autocapitalization: UITextAutocapitalizationType = .sentences
    private var autocorrection: UITextAutocorrectionType = .default
    private var keyboardType: UIKeyboardType = .default
    private var textContentType: UITextContentType?
    private var clearButtonMode: UITextField.ViewMode = .never
    
    // MARK: - UI Customization
    private var mainColor: Color = Color(hexString: "#1E4D80")
    private var errorColor: Color = .red
    private var normalColor: Color = .gray
    private var disabledColor: Color = .gray.opacity(0.5)
    private var backgroundColor: Color = .white
    private var textColor: Color = .black
    private var placeholderColor: Color = .gray
    private var cornerRadius: CGFloat = 8
    private var borderWidth: CGFloat = 1
    private var floatingLabelFont: Font = .caption
    private var errorMessageFont: Font = .caption
    private var textFieldFont: Font = .body
    
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
        
        // Set keyboard type based on style
        switch style {
        case .numeric, .phone:
            self.keyboardType = .numberPad
        case .email:
            self.keyboardType = .emailAddress
        default:
            self.keyboardType = .default
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .topLeading) {
                HStack(spacing: 0) {
                    // Left view if provided
                    if let leftView = leftView {
                        leftView
                            .padding(.leading, 8)
                    }
                    
                    // Input field
                    inputField
                        .padding(.leading, leftView == nil ? 12 : 4)
                        .frame(minHeight: 40)
                        .focused($isTyping)
                        .disabled(!isEnabled)
                        .disabled(!isTextFieldEnabled)
                        .submitLabel(returnKeyType == .next ? .next : .return)
                        .onSubmit {
                            if case .error = validationState {
                                return
                            }
                            onSubmit?()
                        }
                        .autocapitalization(autocapitalization)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .disableAutocorrection(autocorrection == .no)
                        .foregroundColor(textColor)
                        .font(textFieldFont)
                    
                    // Clear button if enabled
                    if clearButtonMode != .never && !text.isEmpty && isTyping {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(normalColor)
                        }
                        .padding(.trailing, 8)
                        .transition(.opacity)
                    }
                    
                    // Right view if provided
                    if let rightView = rightView {
                        rightView
                            .padding(.trailing, 8)
                    } else if style == .secure {
                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(normalColor)
                        }
                        .padding(.trailing, 12)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: borderWidth)
                        .background(backgroundColor)
                        .animation(.easeInOut(duration: 0.2), value: validationState)
                )
                .overlay(
                    floatingLabel
                        .padding(.leading, leftView == nil ? 18 : 30),
                    alignment: .topLeading
                )
                
                // Required indicator
                if isRequired {
                    Text("*")
                        .foregroundColor(errorColor)
                        .padding(.leading, leftView == nil ? -10 :-5)
                        .padding(.top, -15)
                }
            }
            
            // Bottom row with error message and character count
            HStack {
                if case let .error(message) = validationState {
                    Text(message)
                        .font(errorMessageFont)
                        .foregroundColor(errorColor)
                        .padding(.leading, 8)
                        .transition(.opacity)
                }
                
                Spacer()
                
                if showCharacterCount, let limit = characterLimit {
                    Text("\(text.count)/\(limit)")
                        .font(.caption)
                        .foregroundColor(text.count > limit ? errorColor : normalColor)
                }
            }
            .frame(height: 20)
        }
        .onAppear {
            validate()
        }
        .onChange(of: text) { _, newValue in
            // Handle character limit
            if let limit = characterLimit, newValue.count > limit {
                text = String(newValue.prefix(limit))
            }
            validate()
        }
        .onChange(of: isTyping) { _, newValue in
            onEditingChanged?(newValue)
            if !newValue {
                onCommit?()
            }
            validate()
        }
    }
    
    // MARK: - Computed Properties
    
    private var borderColor: Color {
        if !isEnabled {
            return disabledColor
        }
        switch validationState {
        case .error:
            return errorColor
        case .valid:
            return mainColor
        case .none:
            return isTyping ? mainColor : normalColor
        }
    }
    
    private var floatingLabel: some View {
        Text(title)
            .font(floatingLabelFont)
            .padding(.horizontal, 5)
            .background(backgroundColor)
            .foregroundColor(labelColor)
            .scaleEffect(isTyping || !text.isEmpty ? 0.85 : 1.0, anchor: .leading)
            .offset(y: isTyping || !text.isEmpty ? -11 : 15)
            .onTapGesture {
                isTyping = true
            }
            .animation(.linear(duration: 0.1), value: isTyping || !text.isEmpty)
    }
    
    private var labelColor: Color {
        if !isEnabled {
            return disabledColor
        }
        switch validationState {
        case .error:
            return errorColor
        case .valid:
            return mainColor
        case .none:
            return isTyping ? mainColor : normalColor
        }
    }
    
    // MARK: - Input Field Builder
    
    @ViewBuilder
    private var inputField: some View {
        switch style {
        case .multiline:
            TextEditor(text: $text)
                .background(Color.clear)
                .frame(maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .onTapGesture {
                    isTyping = true
                }
            
        case .secure:
            if isSecure {
                SecureField("", text: $text)
            } else {
                TextField("", text: $text)
            }
            
        case .numeric, .phone:
            TextField("", text: $text)
                .keyboardType(.numberPad)
                .onReceive(text.publisher.collect()) {
                    let filtered = $0.filter { "0123456789".contains($0) }
                    text = String(filtered)
                }
            
        case .email:
            TextField("", text: $text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textContentType(.emailAddress)
            
        default:
            TextField("", text: $text)
        }
    }
    
    // MARK: - Validation
    
    private func validate() {
        if isRequired && text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationState = .error("\(title) is required")
            return
        }
        
        if let validator = validator, let error = validator.validate(text) {
            validationState = .error(error)
            return
        }
        
        if text.isEmpty {
            validationState = .none
        } else {
            validationState = .valid
        }
    }
    
}

public extension FloatingLabelTextField {
    
    // MARK: Validation
    
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
    
    // MARK: Views
    
    func rightView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> FloatingLabelTextField {
        var view = self
        view._rightView = State(initialValue: AnyView(content()))
        return view
    }
    
    func leftView<Content: View>(@ViewBuilder content: @escaping () -> Content) -> FloatingLabelTextField {
        var view = self
        view._leftView = State(initialValue: AnyView(content()))
        return view
    }
    
    // MARK: Behavior
    
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
    
    func onEditingChanged(_ action: @escaping (Bool) -> Void) -> FloatingLabelTextField {
        var view = self
        view.onEditingChanged = action
        return view
    }
    
    func onCommit(_ action: @escaping () -> Void) -> FloatingLabelTextField {
        var view = self
        view.onCommit = action
        return view
    }
    
    func clearButtonMode(_ mode: UITextField.ViewMode) -> FloatingLabelTextField {
        var view = self
        view.clearButtonMode = mode
        return view
    }
    
    // MARK: Character Limit
    
    func characterLimit(_ limit: Int?, showCount: Bool = false) -> FloatingLabelTextField {
        var view = self
        view.characterLimit = limit
        view.showCharacterCount = showCount
        return view
    }
    
    // MARK: Text Input Configuration
    
    func autocapitalization(_ style: UITextAutocapitalizationType) -> FloatingLabelTextField {
        var view = self
        view.autocapitalization = style
        return view
    }
    
    func autocorrection(_ style: UITextAutocorrectionType) -> FloatingLabelTextField {
        var view = self
        view.autocorrection = style
        return view
    }
    
    func keyboardType(_ type: UIKeyboardType) -> FloatingLabelTextField {
        var view = self
        view.keyboardType = type
        return view
    }
    
    func textContentType(_ type: UITextContentType?) -> FloatingLabelTextField {
        var view = self
        view.textContentType = type
        return view
    }
    
    // MARK: UI Customization
    
    func mainColor(_ color: Color) -> FloatingLabelTextField {
        var view = self
        view.mainColor = color
        return view
    }
    
    func errorColor(_ color: Color) -> FloatingLabelTextField {
        var view = self
        view.errorColor = color
        return view
    }
    
    func normalColor(_ color: Color) -> FloatingLabelTextField {
        var view = self
        view.normalColor = color
        return view
    }
    
    func disabledColor(_ color: Color) -> FloatingLabelTextField {
        var view = self
        view.disabledColor = color
        return view
    }
    
    func backgroundColor(_ color: Color) -> FloatingLabelTextField {
        var view = self
        view.backgroundColor = color
        return view
    }
    
    func textColor(_ color: Color) -> FloatingLabelTextField {
        var view = self
        view.textColor = color
        return view
    }
    
    func placeholderColor(_ color: Color) -> FloatingLabelTextField {
        var view = self
        view.placeholderColor = color
        return view
    }
    
    func cornerRadius(_ radius: CGFloat) -> FloatingLabelTextField {
        var view = self
        view.cornerRadius = radius
        return view
    }
    
    func borderWidth(_ width: CGFloat) -> FloatingLabelTextField {
        var view = self
        view.borderWidth = width
        return view
    }
    
    func floatingLabelFont(_ font: Font) -> FloatingLabelTextField {
        var view = self
        view.floatingLabelFont = font
        return view
    }
    
    func errorMessageFont(_ font: Font) -> FloatingLabelTextField {
        var view = self
        view.errorMessageFont = font
        return view
    }
    
    func textFieldFont(_ font: Font) -> FloatingLabelTextField {
        var view = self
        view.textFieldFont = font
        return view
    }
}

public extension View {
    
    func isEnabled(_ isEnabled: Bool) -> some View {
        self.modifier(EnableFieldModifier(isEnabled: isEnabled))
    }
    
}

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
