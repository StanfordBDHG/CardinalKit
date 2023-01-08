//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit


/// <#Description#>
public protocol FirestoreElementAdapter<
    InputElement,
    InputRemovalContext
>: SingleValueAdapter where OutputElement: FirestoreElement, OutputRemovalContext: FirestoreRemovalContext { }
