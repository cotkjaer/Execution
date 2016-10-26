//
//  SpinLock.swift
//  Execution
//
//  Created by Christian Otkjær on 01/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/**
 Swiftified version of OSSpinLock.
 
 Use when the lock is taken often, contention is low, and the locked code runs quickly. It has low overhead and thus helps performance for hot code paths.
 
 Do NOT use when code may hold the lock for a substantial amount of time, or contention is common, as it will waste CPU time.
 */

import os

open class SpinLock
{
    fileprivate var spinLock = os_unfair_lock()
    
    /** Locks the spinlock if it would not block
     
     - returns: `true` if it took the lock successfully, `false` if the lock was already held by another thread.
     */
    open func tryLock() -> Bool
    {
        return os_unfair_lock_trylock(&spinLock)
    }
    
    /** Locks the spinlock, blocks until the lock can be locked
     */
    open func lock()
    {
        return os_unfair_lock_lock(&spinLock)
    }
    
    /** Unlocks the spinlock
     */
    open func unlock()
    {
        return os_unfair_lock_unlock(&spinLock)
    }
    
    /** Locks, executes block, unlocks
     */
    open func execute<T>(_ block: () -> T) -> T
    {
        lock()
        
        let result : T = block()
        
        unlock()
        
        return result
    }
}
