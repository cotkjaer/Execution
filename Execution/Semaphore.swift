//
//  Semaphore.swift
//  Execution
//
//  Created by Christian Otkjær on 30/06/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/*
/**
 A Swift wrapper for GCD dispatch semaphores
 */
open class CountingSemaphore
{
    fileprivate var dispatch_semaphore: DispatchSemaphore
    
    /** Initialize the semaphore.
     
    Passing a `value` of zero is useful for when two threads need to reconcile the completion of a particular event.
     
    Passing a `value` greater than zero is useful for managing a finite pool of resources, where the pool size is equal to the value.
     
    - parameter value : the starting value for the semaphore
    */
    public init(value: UInt)
    {
        dispatch_semaphore = DispatchSemaphore(value: Int(value))
    }
    
    fileprivate func execute(_ timeout: UInt64, block: () -> ()) -> Bool
    {
        fatalError()
        if dispatch_semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: timeout) ) == 0
        {
            block()
            
            dispatch_semaphore.signal()
            
            return true
        }
        
        return false
    }
    
    open func now(_ block: ()->()) -> Bool
    {
        return execute(DispatchTime.now(), block: block)
        
//        guard dispatch_semaphore_wait( dispatch_semaphore, DISPATCH_TIME_NOW ) == 0 else { return false }
//        
//        block()
//        
//        dispatch_semaphore_signal( dispatch_semaphore )
//        
//        return true
    }
    
    open func wait(_ block: ()->())
    {
        execute(DispatchTime.distantFuture, block: block)
//        
//        dispatch_semaphore_wait( dispatch_semaphore, DISPATCH_TIME_FOREVER )
//        
//        block()
//        
//        dispatch_semaphore_signal( dispatch_semaphore )
    }
    
//    deinit
//    {
//        dispatch_release(dispatch_semaphore)
//    }
    
}
*/
