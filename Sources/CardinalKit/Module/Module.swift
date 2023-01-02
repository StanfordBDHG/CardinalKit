//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


/// A ``Module`` is a larger ``Component`` that is a ``LifecycleHandler``, persisted in the ``CardinalKit`` instance's ``CardinalKit/CardinalKit/typedCollection`` (using a conformance to ``TypedCollectionKey``), injected in the SwiftUI view hierachy (``ObservableObjectProvider`` & `ObservableObject`), and defined ``Component`` dependencies using `@```Component/Dependency`` property wrapper.
public typealias Module = Component & LifecycleHandler & ObservableObjectProvider & ObservableObject & TypedCollectionKey
