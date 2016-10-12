//
//  Timer.swift
//  Execution
//
//  Created by Christian Otkjær on 09/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation
/*
open class Timer
{
    fileprivate let delay : Delay
    fileprivate let queue : Dispatch.DispatchQueue
    fileprivate let timer : DispatchSource
    fileprivate let leeway : UInt64
    fileprivate let completion : (Bool) -> ()
    
    
    internal init(delay: Delay, leeway: Int = 1_000_000, completion: @escaping (_ completed: Bool) -> ())
    {
        self.delay = delay
        self.leeway = UInt64(leeway)
        self.completion = completion
        
        self.queue = DispatchQueue(label: UUID().uuidString, attributes: dispatch_queue_attr_make_with_qos_class( DispatchQueue.attributes(), DispatchQoS.QoSClass.default, QOS_MIN_RELATIVE_PRIORITY ))
        
        self.timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: queue) /*Migrator FIXME: Use DispatchSourceTimer to avoid the cast*/ as! DispatchSource
        
        timer.setCancelHandler { self.cancel() }
        timer.setEventHandler { self.finish() }
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
    public convenience init(interval: TimeInterval, leeway: Int = 1_000_000, completion: (Bool) -> ())
    {
        self.init(delay: .by(interval), leeway: leeway, completion: completion)
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
    public convenience init(date: Date, leeway: Int = 1_000_000, completion: (Bool) -> ())
    {
        self.init(delay: .until(date), leeway: leeway, completion: completion)
    }

    
    open func start()
    {
        guard !cancelled else { return }
        
        guard !finished else { return }
        
        let interval = delay.seconds
        
        guard interval > 0 else { finish(); return }
        
        timer.setTimer(start: DispatchTime.now() + Double(Int64(interval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), interval: DispatchTime.distantFuture, leeway: leeway)
        
        timer.resume()
    }
    
    open var cancelled : Bool { return timer.isCancelled != 0 }
    
    open var cancelHandler : (() -> ())?
        {
        didSet
        {
            timer.setCancelHandler(handler: cancelHandler)
        }
    }
    
    fileprivate func handleCancel()
    {
        cancelHandler?()
    }
    
    open func cancel()
    {
        timer.cancel()
    }
    
    open fileprivate(set) var finished : Bool = false
    
    fileprivate func finish()
    {
        let completed = !cancelled
        
        finished = true
        
        completion(completed)
    }
}
*/
