//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation


// swiftlint:disable generic_type_name line_length

private actor TwoAdapterChain<
        InputElement: Identifiable & Sendable,
        InputRemovalContext: Identifiable & Sendable,
        IntermediateElement: Identifiable & Sendable,
        IntermediateRemovalContext: Identifiable & Sendable,
        OutputElement: Identifiable & Sendable,
        OutputRemovalContext: Identifiable & Sendable
    >: Actor, Adapter
    where InputElement.ID: Sendable, InputElement.ID == InputRemovalContext.ID,
          IntermediateElement.ID: Sendable, IntermediateElement.ID == IntermediateRemovalContext.ID,
          OutputElement.ID: Sendable, OutputElement.ID == OutputRemovalContext.ID {
    let firstDataSourceRegistryAdapter: any Adapter<InputElement, InputRemovalContext, IntermediateElement, IntermediateRemovalContext>
    let secondDataSourceRegistryAdapter: any Adapter<IntermediateElement, IntermediateRemovalContext, OutputElement, OutputRemovalContext>
    
    
    init(
        firstDataSourceRegistryAdapter: any Adapter<InputElement, InputRemovalContext, IntermediateElement, IntermediateRemovalContext>,
        secondDataSourceRegistryAdapter: any Adapter<IntermediateElement, IntermediateRemovalContext, OutputElement, OutputRemovalContext>
    ) {
        self.firstDataSourceRegistryAdapter = firstDataSourceRegistryAdapter
        self.secondDataSourceRegistryAdapter = secondDataSourceRegistryAdapter
    }
    
    
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
    ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>> {
        let firstDataSourceRegistryTransformation = await firstDataSourceRegistryAdapter.transform(asyncSequence)
        return await secondDataSourceRegistryAdapter.transform(firstDataSourceRegistryTransformation)
    }
}

private actor ThreeAdapterChain<
        InputElement: Identifiable & Sendable,
        InputRemovalContext: Identifiable & Sendable,
        IntermediateElementOne: Identifiable & Sendable,
        IntermediateRemovalContextOne: Identifiable & Sendable,
        IntermediateElementTwo: Identifiable & Sendable,
        IntermediateRemovalContextTwo: Identifiable & Sendable,
        OutputElement: Identifiable & Sendable,
        OutputRemovalContext: Identifiable & Sendable
    >: Actor, Adapter
    where InputElement.ID: Sendable, InputElement.ID == InputRemovalContext.ID,
          IntermediateElementOne.ID: Sendable, IntermediateElementOne.ID == IntermediateRemovalContextOne.ID,
          IntermediateElementTwo.ID: Sendable, IntermediateElementTwo.ID == IntermediateRemovalContextTwo.ID,
          OutputElement.ID: Sendable, OutputElement.ID == OutputRemovalContext.ID {
    let firstDataSourceRegistryAdapter: any Adapter<InputElement, InputRemovalContext, IntermediateElementOne, IntermediateRemovalContextOne>
    let secondDataSourceRegistryAdapter: any Adapter<IntermediateElementOne, IntermediateRemovalContextOne, IntermediateElementTwo, IntermediateRemovalContextTwo>
    let thirdDataSourceRegistryAdapter: any Adapter<IntermediateElementTwo, IntermediateRemovalContextTwo, OutputElement, OutputRemovalContext>
    
    
    init(
        firstDataSourceRegistryAdapter: any Adapter<InputElement, InputRemovalContext, IntermediateElementOne, IntermediateRemovalContextOne>,
        secondDataSourceRegistryAdapter: any Adapter<IntermediateElementOne, IntermediateRemovalContextOne, IntermediateElementTwo, IntermediateRemovalContextTwo>,
        thirdDataSourceRegistryAdapter: any Adapter<IntermediateElementTwo, IntermediateRemovalContextTwo, OutputElement, OutputRemovalContext>
    ) {
        self.firstDataSourceRegistryAdapter = firstDataSourceRegistryAdapter
        self.secondDataSourceRegistryAdapter = secondDataSourceRegistryAdapter
        self.thirdDataSourceRegistryAdapter = thirdDataSourceRegistryAdapter
    }
    
    
    func transform(
        _ asyncSequence: some TypedAsyncSequence<DataChange<InputElement, InputRemovalContext>>
    ) async -> any TypedAsyncSequence<DataChange<OutputElement, OutputRemovalContext>> {
        let firstDataSourceRegistryTransformation = await firstDataSourceRegistryAdapter.transform(asyncSequence)
        let secondDataSourceRegistryTransformation = await secondDataSourceRegistryAdapter.transform(firstDataSourceRegistryTransformation)
        return await thirdDataSourceRegistryAdapter.transform(secondDataSourceRegistryTransformation)
    }
}


/// A function builder used to generate data source registry adapter chains.
@resultBuilder
public enum AdapterBuilder<OutputElement: Identifiable & Sendable, OutputRemovalContext: Identifiable & Sendable> where OutputElement.ID: Sendable, OutputElement.ID == OutputRemovalContext.ID {
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock<
            InputElement: Identifiable & Sendable, InputRemovalContext: Identifiable & Sendable
        > (
            _ dataSourceRegistryAdapter: any Adapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>
        ) -> any Adapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>
        where InputElement.ID: Sendable, InputElement.ID == InputRemovalContext.ID {
        dataSourceRegistryAdapter
    }
    
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock<
            InputElement: Identifiable & Sendable, InputRemovalContext: Identifiable & Sendable,
            IntermediateElement: Identifiable & Sendable, IntermediateRemovalContext: Identifiable & Sendable
        > (
            _ firstDataSourceRegistryAdapter: any Adapter<InputElement, InputRemovalContext, IntermediateElement, IntermediateRemovalContext>,
            _ secondDataSourceRegistryAdapter: any Adapter<IntermediateElement, IntermediateRemovalContext, OutputElement, OutputRemovalContext>
        ) -> any Adapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>
        where InputElement.ID: Sendable, InputElement.ID == InputRemovalContext.ID,
              IntermediateElement.ID: Sendable, IntermediateElement.ID == IntermediateRemovalContext.ID {
        TwoAdapterChain(
            firstDataSourceRegistryAdapter: firstDataSourceRegistryAdapter,
            secondDataSourceRegistryAdapter: secondDataSourceRegistryAdapter
        )
    }
    
    /// Required by every result builder to build combined results from statement blocks.
    public static func buildBlock<
            InputElement: Identifiable & Sendable, InputRemovalContext: Identifiable & Sendable,
            IntermediateElement1: Identifiable & Sendable, IntermediateRemovalContext1: Identifiable & Sendable,
            IntermediateElement2: Identifiable & Sendable, IntermediateRemovalContext2: Identifiable & Sendable
        > (
            _ firstDataSourceRegistryAdapter: any Adapter<InputElement, InputRemovalContext, IntermediateElement1, IntermediateRemovalContext1>,
            _ secondDataSourceRegistryAdapter: any Adapter<IntermediateElement1, IntermediateRemovalContext1, IntermediateElement2, IntermediateRemovalContext2>,
            _ thirdDataSourceRegistryAdapter: any Adapter<IntermediateElement2, IntermediateRemovalContext2, OutputElement, OutputRemovalContext>
        ) -> any Adapter<InputElement, InputRemovalContext, OutputElement, OutputRemovalContext>
        where InputElement.ID: Sendable, InputElement.ID == InputRemovalContext.ID,
              IntermediateElement1.ID: Sendable, IntermediateElement1.ID == IntermediateRemovalContext1.ID,
              IntermediateElement2.ID: Sendable, IntermediateElement2.ID == IntermediateRemovalContext2.ID {
        ThreeAdapterChain(
            firstDataSourceRegistryAdapter: firstDataSourceRegistryAdapter,
            secondDataSourceRegistryAdapter: secondDataSourceRegistryAdapter,
            thirdDataSourceRegistryAdapter: thirdDataSourceRegistryAdapter
        )
    }
}
