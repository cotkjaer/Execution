//
//  NSOperation+State.swift
//  Execution
//
//  Created by Christian Otkjær on 08/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - State

extension Operation
{
    public var state : State
    {
        if isCancelled
        {
            return .cancelled
        }
        else if isFinished
        {
            return .completed
        }
        else if isExecuting
        {
            return .executing
        }
        else if isReady
        {
            return .ready
        }
        else
        {
            return .initial
        }
    }

    public enum State: Int
    {
        // The initial state
        case initial
        
        // Ready to begin executing
        case ready
        
        // Operation is executing
        case executing
        
        // Operation has finished and was completed
        case completed
        
        // Operation was cancelled
        case cancelled
    }
}
