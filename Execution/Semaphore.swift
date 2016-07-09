//
//  Semaphore.swift
//  Execution
//
//  Created by Christian Otkjær on 30/06/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/**
 A Swift wrapper for GCD dispatch semaphores
 */
public class CountingSemaphore
{
    private var dispatch_semaphore: dispatch_semaphore_t
    
    /** Initialize the semaphore.
     
    Passing a `value` of zero is useful for when two threads need to reconcile the completion of a particular event.
     
    Passing a `value` greater than zero is useful for managing a finite pool of resources, where the pool size is equal to the value.
     
    - parameter value : the starting value for the semaphore
    */
    public init(value: UInt)
    {
        dispatch_semaphore = dispatch_semaphore_create(Int(value))
    }
    
    private func execute(timeout: UInt64, block: () -> ()) -> Bool
    {
        if dispatch_semaphore_wait( dispatch_semaphore, timeout ) == 0
        {
            block()
            
            dispatch_semaphore_signal( dispatch_semaphore )
            
            return true
        }
        
        return false
    }
    
    public func now(block: ()->()) -> Bool
    {
        return execute(DISPATCH_TIME_NOW, block: block)
        
//        guard dispatch_semaphore_wait( dispatch_semaphore, DISPATCH_TIME_NOW ) == 0 else { return false }
//        
//        block()
//        
//        dispatch_semaphore_signal( dispatch_semaphore )
//        
//        return true
    }
    
    public func wait(block: ()->())
    {
        execute(DISPATCH_TIME_FOREVER, block: block)
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