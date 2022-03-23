//
//  AsyncOperation.swift
//  EATWidget
//
//  Created by Adrian Vatchinsky on 3/23/22.
//

import Foundation

extension AsyncOperation {
    enum State: String {
        case ready, executing, finished

        fileprivate var keyPath: String {
            "is\(rawValue.capitalized)"
        }
    }
}

class AsyncOperation: Operation {
    // Create state management
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    // Override properties
    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override func cancel() {
        state = .finished
    }

    override var isAsynchronous: Bool {
        return true
    }

    override func start() {
        if isCancelled {
            state = .finished
            return
        }
    
        main()
        state = .executing
    }
}
