//
//  DispatchQoS.QoSClass.swift
//  Execution
//
//  Created by Christian Otkjær on 26/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

extension DispatchQoS.QoSClass
{
    var dispatchQueue: DispatchQueue
    {
        return DispatchQueue.global(qos: self)
    }
}
