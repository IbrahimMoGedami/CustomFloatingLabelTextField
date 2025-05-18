# FloatingBorderTextField

`FloatingBorderTextField` is a customizable SwiftUI view that provides a floating label text field with support for validation, secure input, multiline input, and custom right views. It includes customizable error handling and the ability to display validation messages.

## Features

- Floating label that animates when the text field is focused or has text.
- Customizable border color based on text field state (focused, error, default).
- Support for secure input (password fields) with a toggle button to show/hide the password.
- Support for multiline input using `TextEditor`.
- Built-in validation support for common validation types (e.g., required fields, email, numeric, password).
- Option to add a custom right view (e.g., a dropdown menu, icons).
- Optional error messages displayed below the text field.
- Disabling the text field based on a condition.

## Usage

### Basic Example

```swift
FloatingBorderTextField(title: "First Name", text: $firstNameTextField)
    .validation(NameValidator())
    .required()
```

### Password Field Example

```swift
FloatingBorderTextField(title: "Password", text: $password, isSecureField: true)
    .validation(MyPasswordValidator())
```

### Multiline Text Field Example

```swift
FloatingBorderTextField(title: "Notes", text: $notes, isMultiline: true)
```

### Adding a Custom Right View (e.g., Dropdown Menu)

```swift
FloatingBorderTextField(title: "Country", text: $country)
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
```

### Validation

You can apply custom validation to the text field using the `.validation()` modifier.

```swift
FloatingBorderTextField(title: "Email", text: $emailTextField)
    .validation(ValidationFactory.email)
```

### Required Fields

To mark a field as required, use the `.required()` modifier.

```swift
FloatingBorderTextField(title: "First Name", text: $firstNameTextField)
    .required()
```

### Validators

Validators ensure the entered text meets certain criteria. You can create custom validators or use the built-in ones:

- **NonEmptyValidator**: Ensures the text is not empty.
- **EmailValidator**: Validates email format.
- **NumericValidator**: Ensures the text is numeric.
- **MyPasswordValidator**: Custom password validation (e.g., length, uppercase, special characters).

## Installation

To use `FloatingBorderTextField` in your project, simply add the SwiftUI view and validator logic to your codebase. No external dependencies are required.
