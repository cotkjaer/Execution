//
//  Timer.swift
//  Execution
//
//  Created by Christian Otkjær on 09/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

public class Timer
{
    private let delay : Delay
    private let queue : dispatch_queue_t
    private let timer : dispatch_source_t
    private let leeway : UInt64
    private let completion : (Bool) -> ()
    
    
    internal init(delay: Delay, leeway: Int = 1_000_000, completion: (completed: Bool) -> ())
    {
        self.delay = delay
        self.leeway = UInt64(leeway)
        self.completion = completion
        
        self.queue = dispatch_queue_create(NSUUID().UUIDString, dispatch_queue_attr_make_with_qos_class( DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, QOS_MIN_RELATIVE_PRIORITY ))
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        
        dispatch_source_set_cancel_handler(timer) { self.cancel() }
        dispatch_source_set_event_handler(timer) { self.finish() }
    }
    
    /**
     Initialize the `DelayOperation` with a time interval.
     
     - parameter interval: a `NSTimeInterval`.
     - parameter leeway: an `Int` representing leeway of
     nanoseconds for the timer. This defaults to 1_000_000
     meaning the timer is accurate to milli-second accuracy.
     This is partly from a energy standpoint as nanosecond
     accuracy is costly.
     */
    public convenience init(interval: NSTimeInterval, leeway: Int = 1_000_000, completion: (Bool) -> ())
    {
        self.init(delay: .By(interval), leeway: leeway, completion: completion)
    }
    
    /**
     Initialize the `DelayOperation` with a date.
     
     - parameter interval: a `NSDate`.
     - parameter leeway: an `Int` representing leeway of
     nanoseconds for the timer. This defaults to 1_000_000
     meaning the timer is accurate to milli-second accuracy.
     This is partly from a energy standpoint as nanosecond
     accuracy is costly.
     */
    public convenience init(date: NSDate, leeway: Int = 1_000_000, completion: (Bool) -> ())
    {
        self.init(delay: .Until(date), leeway: leeway, completion: completion)
    }

    
    public func start()
    {
        guard !cancelled else { return }
        
        guard !finished else { return }
        
        let interval = delay.seconds
        
        guard interval > 0 else { finish(); return }
        
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC))), DISPATCH_TIME_FOREVER, leeway)
        
        dispatch_resume(timer)
    }
    
    public var cancelled : Bool { return dispatch_source_testcancel( timer ) != 0 }
    
    public var cancelHandler : (() -> ())?
        {
        didSet
        {
            dispatch_source_set_cancel_handler(timer, cancelHandler)
        }
    }
    
    private func handleCancel()
    {
        cancelHandler?()
    }
    
    public func cancel()
    {
        dispatch_source_cancel(timer)
    }
    
    public private(set) var finished : Bool = false
    
    private func finish()
    {
        let completed = !cancelled
        
        finished = true
        
        completion(completed)
    }
}