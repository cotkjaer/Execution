//
//  DispatchQueue.swift
//  Execution
//
//  Created by Christian Otkjær on 26/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

extension DispatchQueue
{
    public func async(delayed seconds: Double, execute closure: @escaping ()->())
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
