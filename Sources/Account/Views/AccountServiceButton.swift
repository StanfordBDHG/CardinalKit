//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct AccountServiceButton<Content: View>: View {
    private let content: Content
    
    
    var body: some View {
        HStack {
            content
        }
            .foregroundColor(.accentColor)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.accentColor, lineWidth: 2)
                    .padding(1)
            )
            .cornerRadius(8)
    }
    
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
}


struct UsernamePasswordLoginServiceButton_Previews: PreviewProvider {
    static var previews: some View {
        AccountServiceButton {
            Image(systemName: "ellipsis.rectangle")
                .font(.title2)
            Text("LOGIN_UAP_BUTTON_TITLE", bundle: .module)
        }
    }
}
