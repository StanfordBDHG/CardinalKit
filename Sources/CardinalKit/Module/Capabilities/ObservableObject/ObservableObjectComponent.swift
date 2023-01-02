//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A ``Component`` can conform to ``ObservableObjectProvider`` to inject an `ObservableObject`s in the SwiftUI view hierachy using ``ObservableObjectProvider/observableObjects-6w1nz``
public protocol ObservableObjectProvider {
    /// The `ObservableObject` instances that should be injected in the SwiftUI environment.
    var observableObjects: [any ObservableObject] { get }
}


private struct ObservableObjectInjectionViewModifier: ViewModifier {
    let apply: (AnyView) -> AnyView
    
    
    init<O: ObservableObject>(observableObject: O) {
        apply = { view in
            AnyView(view.environmentObject(observableObject))
        }
    }
    
    
    func body(content: Content) -> some View {
        apply(AnyView(content))
    }
}


extension ObservableObjectProvider {
    // A documentation for this methodd exists in the `ObservableObjectProvider` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public var observableObjects: [any ObservableObject] {
        []
    }
    
    
    func inject(in view: AnyView) -> AnyView {
        var view = view
        for observableObject in observableObjects {
            let modifier = ObservableObjectInjectionViewModifier(observableObject: observableObject)
            view = AnyView(view.modifier(modifier))
        }
        return view
    }
}

extension ObservableObjectProvider where Self: ObservableObject {
    // A documentation for this methodd exists in the `ObservableObjectProvider` type which SwiftLint doesn't recognize.
    // swiftlint:disable:next missing_docs
    public var observableObjects: [any ObservableObject] {
        [self]
    }
}
