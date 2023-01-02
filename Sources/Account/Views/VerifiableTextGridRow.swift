//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
import Views


struct VerifiableTextFieldGridRow<Description: View, TextField: View>: View {
    private let description: Description
    private let textField: TextField
    private let validationRules: [ValidationRule]
    
    @Binding private var text: String
    @Binding private var valid: Bool
    
    @State private var debounceTask: Task<Void, Never>? {
        willSet {
            self.debounceTask?.cancel()
        }
    }
    @State private var validationResults: [String] = []
    
    
    var body: some View {
        DescriptionGridRow {
            description
        } content: {
            VStack {
                textField
                    .onSubmit {
                        validation()
                    }
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(validationResults, id: \.self) { message in
                            Text(message)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                        .gridColumnAlignment(.leading)
                        .font(.footnote)
                        .foregroundColor(.red)
                    Spacer(minLength: 0)
                }
            }
        }
            .onChange(of: text) { _ in
                validation()
            }
            .onTapFocus()
    }
    
    
    init(
        text: Binding<String>,
        valid: Binding<Bool>,
        validationRules: [ValidationRule] = [],
        @ViewBuilder description: () -> Description,
        @ViewBuilder textField: (Binding<String>) -> TextField
    ) {
        self._text = text
        self._valid = valid
        self.validationRules = validationRules
        self.description = description()
        self.textField = textField(text)
    }
    
    // We want to have the same argument order as found in the main initializer. We do not move the description property up as it constructs a trailing closure in the main initializer.
    // swiftlint:disable:next function_default_parameter_at_end
    init(
        text: Binding<String>,
        valid: Binding<Bool>,
        validationRules: [ValidationRule] = [],
        description: String,
        @ViewBuilder textField: (Binding<String>) -> TextField
    ) where Description == Text {
        self.init(
            text: text,
            valid: valid,
            description: { Text(description) },
            textField: textField
        )
    }
    
    
    private func validation() {
        debounceTask = Task {
            // Wait 0.5 seconds until you start the validation.
            try? await Task.sleep(for: .seconds(0.2))
            
            guard !Task.isCancelled else {
                return
            }
            
            SwiftUI.withAnimation(.easeInOut(duration: 0.2)) {
                defer {
                    updateValid()
                }
                
                guard !text.isEmpty else {
                    validationResults = []
                    return
                }
                
                validationResults = validationRules.compactMap { $0.validate(text) }
            }
            
            self.debounceTask = nil
        }
    }
    
    private func updateValid() {
        valid = !text.isEmpty && validationResults.isEmpty
    }
}


struct VerifiableTextFieldGridRow_Previews: PreviewProvider {
    private enum Field: Hashable {
        case first
        case second
    }
    
    
    @State private static var text: String = ""
    @State private static var valid = false
    @FocusState private static var focusedField: Field?
    
    
    static var previews: some View {
        VStack {
            Form {
                views
                    .padding(4)
            }
            views
                .padding(32)
        }
            .background(Color(.systemGroupedBackground))
    }
    
    private static var views: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            VerifiableTextFieldGridRow(
                text: $text,
                valid: $valid,
                description: {
                    Text("Text")
                },
                textField: { binding in
                    TextField(text: binding) {
                        Text("Placeholder ...")
                    }
                }
            )
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .first)
            Divider()
            VerifiableTextFieldGridRow(
                text: $text,
                valid: $valid,
                description: {
                    Text("Text")
                },
                textField: { binding in
                    SecureField(text: binding) {
                        Text("Secure Placeholder ...")
                    }
                }
            )
                .onTapFocus(focusedField: _focusedField, fieldIdentifier: .first)
        }
    }
}
