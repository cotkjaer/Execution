//
//  Async.swift
//  Execution
//
//  Created by Christian Otkjær on 16/09/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Reversed lookup

extension DispatchQoS.QoSClass
{
    var dispatchQueue: DispatchQueue
    {
        return DispatchQueue.global(qos: self)
    }
}

// MARK: - After

extension DispatchQueue
{
    func async(delayed seconds: Double, execute closure: @escaping ()->())
    {
        if seconds < 0
        {
            async(execute: closure)
        }
        else
        {
            let when = DispatchTime.now() + seconds
            
            asyncAfter(deadline: when, execute: closure)
        }
    }
}

private func delay(_ seconds: Double, onQueue queue: DispatchQueue, execute closure: @escaping ()->())
{
    queue.async(delayed: seconds, execute: closure)
}

public func delay(_ seconds: Double, execute closure:@escaping ()->())
{
    delay(seconds, onQueue: DispatchQueue.main, execute: closure)
}

public func background(delay seconds: Double = 0, qos: DispatchQoS.QoSClass = .userInitiated, execute closure: @escaping ()->())
{
    delay(seconds, onQueue: DispatchQueue.global(qos: qos), execute: closure)
}

public func foreground(delay seconds: Double = 0, execute closure: @escaping ()->())
{
    delay(seconds, onQueue: DispatchQueue.main, execute: closure)
}

public func async(execute closure: @escaping ()->())
{
    DispatchQueue.main.async(execute: closure)
}
