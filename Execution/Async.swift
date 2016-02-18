//
//  Async.swift
//  Execution
//
//  Created by Christian Otkjær on 16/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

public enum ExecutionPriority
{
    case High
    case Default
    case Low
    case Lowest
    
    private var dispatch_priority : dispatch_queue_priority_t
        {
            switch self
            {
            case .High: return DISPATCH_QUEUE_PRIORITY_HIGH
            case .Default: return DISPATCH_QUEUE_PRIORITY_DEFAULT
            case .Low: return DISPATCH_QUEUE_PRIORITY_LOW
            case .Lowest: return DISPATCH_QUEUE_PRIORITY_BACKGROUND
            }
    }
    
    func queue() -> dispatch_queue_t
    {
        return dispatch_get_global_queue(dispatch_priority, 0)
    }
}

// MARK: - Delay

//private extension Double
//{
//    var dispatch_time : dispatch_time_t
//        {
//            if self <= 0.0001
//            {
//                return DISPATCH_TIME_NOW
//            }
//            else
//            {
//                return Foundation.dispatch_time(DISPATCH_TIME_NOW, Int64(self * Double(NSEC_PER_SEC)))
//            }
//    }
//}

public extension dispatch_time_t
{
    func delay(delay: Double) -> dispatch_time_t
    {
        if delay < 0
        {
            return self
        }
        else
        {
            return dispatch_time(self, Int64(delay * Double(NSEC_PER_SEC)))
        }
    }
}

public func delay(delay:Double, priority: ExecutionPriority? = nil, closure:()->())
{
    let queue : dispatch_queue_t = priority?.queue() ?? dispatch_get_main_queue()
    
    if delay <= 0.001
    {
        dispatch_async(queue, closure)
    }
    else
    {
        let when = DISPATCH_TIME_NOW.delay(delay)
        
        dispatch_after(
            when,
            queue,
            //        priority?.queue() ?? dispatch_get_main_queue(),
            closure)
    }
}

public func background(delay d: Double = 0, priority: ExecutionPriority = .Default, closure:()->())
{
    delay(d, priority: priority, closure: closure)
//    dispatch_async(priority.queue(), closure)
}

public func foreground(delay d: Double = 0, closure:()->())
{
    delay(d, closure: closure)
    
//    dispatch_async(dispatch_get_main_queue(), closure)
}

public func async(priority: ExecutionPriority? = nil, closure:()->())
{
    let queue : dispatch_queue_t = priority?.queue() ?? dispatch_get_main_queue()

    dispatch_async(queue, closure)
}