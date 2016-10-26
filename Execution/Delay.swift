//
//  Delay.swift
//  Execution
//
//  Created by Christian Otkjær on 08/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

internal func delay(_ seconds: Double, onQueue queue: DispatchQueue, execute closure: @escaping ()->())
{
    queue.async(delayed: seconds, execute: closure)
}

public func delay(_ seconds: Double, execute closure: @escaping ()->())
{
    delay(seconds, onQueue: DispatchQueue.main, execute: closure)
}


