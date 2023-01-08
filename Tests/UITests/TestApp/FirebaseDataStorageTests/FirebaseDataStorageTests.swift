//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
@testable import FirebaseDataStorage
import SwiftUI


struct FirebaseDataStorageTestsView: View {
    @EnvironmentObject var firebaseModule: Firebase<TestAppStandard>
    @State var error: Error?
    @State var displayAlert = false
    
    var body: some View {
        VStack {
            Button("Upload Element") {
                Task {
                    do {
                        try await firebaseModule.process(.addition(TestAppStandard.BaseType(id: "testelement")))
                    } catch {
                        self.error = error
                        self.displayAlert = true
                    }
                }
            }
            Button("Delete Element") {
                Task {
                    do {
                        try await firebaseModule.process(.removal(TestAppStandard.RemovalContext(id: "testelement")))
                    } catch {
                        self.error = error
                        self.displayAlert = true
                    }
                }
            }
        }
            .alert(isPresented: $displayAlert) {
                Alert(title: Text(error?.localizedDescription ?? "Unspecified Error"))
            }
    }
}


struct FirebaseDataStorageTestsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FirebaseDataStorageTestsView()
        }
    }
}
