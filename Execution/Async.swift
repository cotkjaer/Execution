//
//  Async.swift
//  Execution
//
//  Created by Christian Otkjær on 16/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

/*
//public enum ExecutionPriority
//{
//    case high
//    case `default`
//    case low
//    case lowest
//    
//    fileprivate var dispatch_priority : dispatch_queue_priority_t
//        {
//            switch self
//            {
//            case .high: return DispatchQueue.GlobalQueuePriority.high
//            case .default: return DispatchQueue.GlobalQueuePriority.default
//            case .low: return DispatchQueue.GlobalQueuePriority.low
//            case .lowest: return DispatchQueue.GlobalQueuePriority.background
//            }
//    }
//    
//    func queue() -> Dispatch.DispatchQueue
//    {
//        return DispatchQueue.global(priority: dispatch_priority)
//    }
//}

// MARK: - Delay

public extension DispatchTime
{
    func delay(_ delay: Double) -> DispatchTime
    {
        if delay < 0
        {
            return self
        }
        else
        {
            return self + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        }
    }
}
*/

// MARK: - <#comment#>

extension DispatchQueue
{
    func async(after: Double, execute closure: @escaping ()->())
    {
        let when = DispatchTime.now() + after
        
        asyncAfter(deadline: when, execute: closure)
    }
}


private func delay(_ time: Double, onQueue queue: DispatchQueue = DispatchQueue.main, closure: @escaping ()->())
{
    queue.async(after: time, execute: closure)
}

public func delay(_ time: Double, closure:@escaping ()->())
{
    delay(time, onQueue: DispatchQueue.main, closure: closure)
}

public func background(delay d: Double = 0, priority: DispatchQoS = .default, closure:@escaping ()->())
{
    delay(d, onQueue: DispatchQueue.global(qos: .userInitiated), closure: closure)
}

public func foreground(delay d: Double = 0, closure:@escaping ()->())
{
    delay(d, onQueue: DispatchQueue.main, closure: closure)
}

public func async(closure: @escaping ()->())
{
    DispatchQueue.main.async(execute: closure)
}
