//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


extension UUID: Identifiable {
    public var id: UUID {
        self
    }
}

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

extension Double: Identifiable {
    public var id: Double {
        self
    }
}

extension Float: Identifiable {
    public var id: Float {
        self
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
