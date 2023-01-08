//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// <#Description#>
public actor DefaultFirestoreElementAdapter<InputElement: FirestoreElement, InputRemovalContext: FirestoreRemovalContext>: FirestoreElementAdapter {
    public typealias OutputElement = AnyFirestoreElement
    public typealias OutputRemovalContext = AnyFirestoreRemovalContext
    
    
    /// <#Description#>
    public struct AnyFirestoreElement: FirestoreElement {
        fileprivate let element: any FirestoreElement
        
        
        public var collectionPath: String {
            element.collectionPath
        }
        public var id: String {
            element.id
        }
        
        
        fileprivate init(element: some FirestoreElement) {
            self.element = element
        }
        
        
        public func encode(to encoder: Encoder) throws {
            try element.encode(to: encoder)
        }
    }
    
    /// <#Description#>
    public struct AnyFirestoreRemovalContext: FirestoreRemovalContext {
        public let collectionPath: String
        public let id: String
        
        
        fileprivate init(collectionPath: String, id: String) {
            self.collectionPath = collectionPath
            self.id = id
        }
    }
    
    
    /// <#Description#>
    public init() {}


    public func transform(element: InputElement) -> AnyFirestoreElement {
        AnyFirestoreElement(element: element)
    }

    public func transform(removalContext: InputRemovalContext) -> AnyFirestoreRemovalContext {
        AnyFirestoreRemovalContext(collectionPath: removalContext.collectionPath, id: removalContext.id)
    }
 }
