//
//  NSOperation+State.swift
//  Execution
//
//  Created by Christian Otkjær on 08/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - State

extension NSOperation
{
    public var state : State
    {
        if cancelled
        {
            return .Cancelled
        }
        else if finished
        {
            return .Completed
        }
        else if executing
        {
            return .Executing
        }
        else if ready
        {
            return .Ready
        }
        else
        {
            return .Initial
        }
    }

    public enum State: Int
    {
        // The initial state
        case Initial
        
        // Ready to begin executing
        case Ready
        
        // Operation is executing
        case Executing
        
        // Operation has finished and was completed
        case Completed
        
        // Operation was cancelled
        case Cancelled
    }
}
