//
//  Background.swift
//  Execution
//
//  Created by Christian Otkjær on 26/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

public func background(delay seconds: Double = 0, qos: DispatchQoS.QoSClass = .userInitiated, execute closure: @escaping ()->())
{
    delay(seconds, onQueue: DispatchQueue.global(qos: qos), execute: closure)
}
