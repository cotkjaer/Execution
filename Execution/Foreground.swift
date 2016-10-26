//
//  Foreground.swift
//  Execution
//
//  Created by Christian Otkjær on 26/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

public func foreground(delay seconds: Double = 0, execute closure: @escaping ()->())
{
    delay(seconds, onQueue: DispatchQueue.main, execute: closure)
}
