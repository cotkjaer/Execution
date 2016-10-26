//
//  Task.swift
//  Execution
//
//  Created by Christian Otkjær on 18/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

/// A class that encapsulates a closure and enables scheduling
open class Task
{
    // The captured by the block dispatched to GCD needs to match this secret to alow execution of the closure
    fileprivate var secret = 0
    
    ///The number of scheduled executions
    fileprivate(set) var scheduled = 0
    
    ///The captured closure
    fileprivate var closure : (() -> ())
    
    /// Capture and retain a closure
    /// - parameter closure : closure to capture
    public init(_ closure:@escaping ()->())
    {
        self.closure = closure
    }
    
    /// Capture and retain a closure, and schedule it to execute after _delay_ seconds
    /// - parameter delay : time to delay execution of _closure_
    /// - parameter closure : closure to capture
    /// If the delay is negative the task is scheduled to execute in 0.1 seconds
    public convenience init(delay:Double, closure:@escaping ()->())
    {
        self.init(closure)
        schedule(delay)
    }
    
    /// Capture and retain a closure, and schedule it to execute on (or after) _date_
    /// - parameter date : the date to wait for before executing _closure_
    /// - parameter closure : closure to capture
    /// If the date is in the past the closure is scheduled to execute in 0.1 seconds
    public convenience init(date:Date, closure:@escaping ()->())
    {
        self.init(closure)
        schedule(date)
    }
    
    /// Unschedule all schedulled executions of captured closure
    open func unschedule()
    {
        scheduled = 0
        secret += 1
    }
    
    /// Schedule task to execute after _delay_ seconds
    ///
    /// - parameter after : time to delay execution of task
    ///
    /// If the delay is negative the task is scheduled to execute in 0.1 seconds
    open func schedule(_ delayInSeconds: Double)
    {
        let capturedSecret = secret
        
        foreground(delay: delayInSeconds) {[weak self] in if self?.secret == capturedSecret { self?.scheduled -= 1; self?.closure() } }

        scheduled += 1
    }
    
    /// Schedule task to execute after _delay_ seconds if it is not already scheduled
    ///
    /// - parameter after : time to delay execution of task
    ///
    /// If the delay is negative the task is scheduled to execute in 0.1 seconds
    open func scheduleIfNeeded(_ after: Double = 0.1)
    {
        if scheduled < 1
        {
            schedule(after)
        }
    }
    
    /// First unschedules any scheduled executions of task, then scedules a new one after _delay_ seconds
    ///
    /// - parameter after : time to delay execution of task
    ///
    /// If the delay is negative the task is scheduled to execute in 0.1 seconds
    open func reschedule(_ after: Double)
    {
        unschedule()
        
        schedule(after)
    }

    
    /// Schedule task to execute after on or after _date_
    ///
    /// - parameter date : the date to wait for before executing task
    ///
    /// If the date is in the past the task is scheduled to execute in 0.1 seconds
    open func schedule(_ date: Date)
    {
        schedule(max(0.1, date.timeIntervalSinceNow))
    }
    
    /// First unschedules any scheduled executions of task, then scedules a new one on (or after) _date_
    ///
    /// - parameter date : the date to wait for before executing task
    ///
    /// If the date is in the past the task is scheduled to execute in 0.1 seconds
    open func reschedule(_ date: Date)
    {
        unschedule()
        
        schedule(date)
    }
    
    /// Executes the closure now
    open func execute()
    {
        closure()
    }
    
    deinit
    {
        unschedule()
    }
}
