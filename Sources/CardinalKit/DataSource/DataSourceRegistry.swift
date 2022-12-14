//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


/// A ``DataSourceRegistry`` can recieve data from data sources using the ``DataSourceRegistry/registerDataSource(_:)`` method.
/// Each ``DataSourceRegistry`` has a ``DataSourceRegistry/BaseType`` that all data sources should provide.
/// Use ``DataSourceRegistryAdapter``s to transform data of different data sources.
public protocol DataSourceRegistry<BaseType>: Actor {
    /// The ``DataSourceRegistry/BaseType`` that all data sources should provide.
    associatedtype BaseType: Identifiable, Sendable where BaseType.ID: Sendable
    
    
    /// Registers a new data source for the ``DataSourceRegistry``.
    /// - Parameter asyncSequence: The `TypedAsyncSequence<DataChange<BaseType>>` providing the data to the ``DataSourceRegistry``.
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType>>)
}


extension DataSourceRegistry {
    /// Overload of the ``DataSourceRegistry/registerDataSource(_:)`` method to recieve `AsyncStream`s.
    /// - Parameter asyncStream: The `AsyncStream<DataChange<BaseType>>` providing the data to the ``DataSourceRegistry``.
    public func registerDataSource(asyncStream: AsyncStream<DataChange<BaseType>>) {
        registerDataSource(asyncStream)
    }
    
    /// Overload of the ``DataSourceRegistry/registerDataSource(_:)`` method to recieve `AsyncThrowingStream`s.
    /// - Parameter asyncThrowingStream: The `AsyncThrowingStream<DataChange<BaseType>>` providing the data to the ``DataSourceRegistry``.
    public func registerDataSource(asyncThrowingStream: AsyncThrowingStream<DataChange<BaseType>, Error>) {
        registerDataSource(asyncThrowingStream)
    }
}
