//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import CardinalKit
import Scheduler
import XCTest


actor SchedulerTestsStandard: Standard {
    typealias BaseType = CustomDataSourceType<String>
    typealias RemovalContext = CustomDataSourceType<String>
    
    
    struct CustomDataSourceType<T: Hashable>: Equatable, Identifiable {
        let id: T
    }
    
    
    func registerDataSource(_ asyncSequence: some TypedAsyncSequence<DataChange<BaseType, RemovalContext>>) { }
}


final class SchedulerTests: XCTestCase {
    func testObservedObjectCalls() throws {
        let numberOfEvents = 6
        
        let testTask = Task(
            title: "Test Task",
            description: "This is a test task",
            schedule: Schedule(
                start: .now,
                dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                end: .numberOfEvents(numberOfEvents)
            ),
            context: "This is a test context"
        )
        let scheduler = Scheduler<SchedulerTestsStandard, String>(tasks: [testTask])
        
        
        let expectation = XCTestExpectation(description: "Get Updates for all scheduled events.")
        expectation.expectedFulfillmentCount = numberOfEvents
        expectation.assertForOverFulfill = true
        
        var eventCount = 0
        
        let cancellable = scheduler.objectWillChange.sink {
            eventCount += 1
            XCTAssertEqual(eventCount, scheduler.tasks.first?.events(to: .endDate(.now)).count)
            XCTAssertEqual(numberOfEvents - eventCount, scheduler.tasks.first?.events(from: .now).count)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: TimeInterval(numberOfEvents + 3))
        
        cancellable.cancel()
    }
    
    
    func testCompleteEvents() throws { // swiftlint:disable:this function_body_length
        // We use longer functions to test the different observable states in one test function.
        let numberOfEvents = 6
        
        let testTask = Task(
            title: "Test Task",
            description: "This is a test task",
            schedule: Schedule(
                start: .now.addingTimeInterval(60),
                dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                end: .numberOfEvents(numberOfEvents)
            ),
            context: "This is a test context"
        )
        let testTask2 = Task(
            title: "Test Task 2",
            description: "This is a second test task",
            schedule: Schedule(
                start: .now.addingTimeInterval(60),
                dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                end: .numberOfEvents(numberOfEvents)
            ),
            context: "This is a second test context"
        )
        let scheduler = Scheduler<SchedulerTestsStandard, String>(tasks: [testTask, testTask2])
        
        let expectationCompleteEvents = XCTestExpectation(description: "Complete all events")
        expectationCompleteEvents.expectedFulfillmentCount = 12
        expectationCompleteEvents.assertForOverFulfill = true
        
        let expectationObservedObject = XCTestExpectation(description: "Get Updates for all scheduled events.")
        expectationObservedObject.expectedFulfillmentCount = 12
        expectationObservedObject.assertForOverFulfill = true
        
        var fulfilledEventCount = 0
        let cancellable = scheduler.objectWillChange.sink {
            fulfilledEventCount += 1
            XCTAssertEqual(fulfilledEventCount, scheduler.tasks.flatMap { $0.events() }.filter { $0.complete }.count)
            XCTAssertEqual(12 - fulfilledEventCount, scheduler.tasks.flatMap { $0.events() }.filter { !$0.complete }.count)
            expectationObservedObject.fulfill()
        }
        
        let events: Set<Event> = Set(scheduler.tasks.flatMap { $0.events() })
        _Concurrency.Task {
            for event in events {
                await event.complete(true)
                try await _Concurrency.Task.sleep(for: .seconds(0.01))
                expectationCompleteEvents.fulfill()
            }
        }
    
        wait(for: [expectationCompleteEvents, expectationObservedObject], timeout: TimeInterval(2))
        
        XCTAssert(events.allSatisfy { $0.complete })
        XCTAssertEqual(events.count, 12)
        cancellable.cancel()

        let unFulfilledExpectationObservedObject = XCTestExpectation(description: "Get Updates for all scheduled events that are toggled.")
        unFulfilledExpectationObservedObject.expectedFulfillmentCount = 12
        unFulfilledExpectationObservedObject.assertForOverFulfill = true

        var unFulfilledEventCount = 0
        let unFulfilledCancellable = scheduler.objectWillChange.sink {
            unFulfilledEventCount += 1
            XCTAssertEqual(unFulfilledEventCount, scheduler.tasks.flatMap { $0.events() }.filter { !$0.complete }.count)
            XCTAssertEqual(12 - unFulfilledEventCount, scheduler.tasks.flatMap { $0.events() }.filter { $0.complete }.count)
            unFulfilledExpectationObservedObject.fulfill()
        }

        _Concurrency.Task {
            for event in scheduler.tasks.flatMap({ $0.events() }) {
                await event.toggle()
                try await _Concurrency.Task.sleep(for: .seconds(0.01))
            }
        }

        wait(for: [unFulfilledExpectationObservedObject], timeout: TimeInterval(2))

        XCTAssert(scheduler.tasks.flatMap { $0.events() } .allSatisfy { !$0.complete })
        XCTAssertEqual(scheduler.tasks.flatMap { $0.events() } .count, 12)

        unFulfilledCancellable.cancel()
    }
    
    func testCodable() throws {
        let tasks = [
            Task(
                title: "Test Task",
                description: "This is a test task",
                schedule: Schedule(
                    start: .now,
                    dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                    end: .numberOfEvents(2)
                ),
                context: "This is a test context"
            ),
            Task(
                title: "Test Task 2",
                description: "This is a second test task",
                schedule: Schedule(
                    start: .now.addingTimeInterval(10),
                    dateComponents: .init(nanosecond: 500_000_000), // every 0.5 seconds
                    end: .numberOfEvents(2)
                ),
                context: "This is a second test context"
            )
        ]
        
        try encodeAndDecodeTasksAssertion(tasks)
        
        let expectation = XCTestExpectation(description: "Get Updates for all scheduled events.")
        expectation.expectedFulfillmentCount = 4
        expectation.assertForOverFulfill = true
        
        let events: Set<Event> = Set(tasks.flatMap { $0.events() })
        for event in events {
            _Concurrency.Task {
                await event.complete(true)
                expectation.fulfill()
            }
        }
        
        sleep(1)
        wait(for: [expectation], timeout: TimeInterval(2))
        
        XCTAssert(events.allSatisfy { $0.complete })
        XCTAssertEqual(events.count, 4)
        
        try encodeAndDecodeTasksAssertion(tasks)
    }
    
    private func encodeAndDecodeTasksAssertion(_ tasks: [Task<String>]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let data = try encoder.encode(tasks)
        print(try XCTUnwrap(String(data: data, encoding: .utf8)))
        let decodedTasks = try JSONDecoder().decode([Task<String>].self, from: data)
        XCTAssertEqual(tasks, decodedTasks)
    }
    
    func testCurrentCalendarEncoding() throws {
        let json = """
        {
            "completedEvents": [],
            "context": "This is a test context",
            "description": "This is a test task",
            "id": "DEDDE3FF-0A75-4A8C-9F0D-75AD417F1104",
            "schedule" : {
                "calendar": "current",
                "dateComponents": {
                    "nanosecond": 500000000
                },
                "end" : {
                    "numberOfEvents": {
                      "_0" : 42
                    }
                },
                "start" : 694224000
            },
            "title" : "Test Task"
        }
        """
        let task = try JSONDecoder().decode(Task<String>.self, from: Data(json.utf8))
        XCTAssertEqual(task.schedule.calendar, .current)
    }
}
