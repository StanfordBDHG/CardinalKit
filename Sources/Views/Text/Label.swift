//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


private struct _Label: UIViewRepresentable {
    let text: String
    let textStyle: UIFont.TextStyle
    let textAllignment: NSTextAlignment
    let textColor: UIColor
    let numberOfLines: Int
    let preferredMaxLayoutWidth: CGFloat
    
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.preferredFont(forTextStyle: textStyle)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = textAllignment
        label.numberOfLines = numberOfLines
        
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        updateUIView(label, context: context)
        
        return label
    }
    
    func updateUIView(_ label: UILabel, context: Context) {
        label.text = text
        label.preferredMaxLayoutWidth = preferredMaxLayoutWidth
    }
}


/// A ``Label`` is a SwiftUI-based wrapper around a `UILabel` that allows the usage of an `NSTextAlignment` to e.g. justify the text.
public struct Label: View {
    private let text: String
    private let textStyle: UIFont.TextStyle
    private let textAllignment: NSTextAlignment
    private let textColor: UIColor
    private let numberOfLines: Int
    
    
    public var body: some View {
        HorizontalGeometryReader { width in
            _Label(
                text: text,
                textStyle: textStyle,
                textAllignment: textAllignment,
                textColor: textColor,
                numberOfLines: numberOfLines,
                preferredMaxLayoutWidth: width
            )
        }
    }
    
    
    /// Creates a new instance of the SwiftUI-based wrapper around a `UILabel`.
    /// - Parameters:
    ///   - text: The text that should be displayed.
    ///   - textStyle: The `UIFont.TextStyle` of the `UILabel`. Defaults to `.body`.
    ///   - textAllignment: The `NSTextAlignment` of the `UILabel`. Defaults to `.justified`.
    ///   - textColor: The `UIColor` of the `UILabel`. Defaults to `.label`.
    ///   - numberOfLines: The number of lines allowd of the `UILabel`. Defaults to 0 indicating no limit.
    public init(
        _ text: String,
        textStyle: UIFont.TextStyle = .body,
        textAllignment: NSTextAlignment = .justified,
        textColor: UIColor = .label,
        numberOfLines: Int = 0
    ) {
        self.text = text
        self.textStyle = textStyle
        self.textAllignment = textAllignment
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
