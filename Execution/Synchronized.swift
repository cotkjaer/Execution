//
//  Synchronized.swift
//  Execution
//
//  Created by Christian Otkjær on 09/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

func synchronized(_ object: AnyObject, closure: () -> ())
{
    objc_sync_enter(object)
    closure()
    objc_sync_exit(object)
}

func synchronized<T>(_ object: AnyObject, closure: () -> T) -> T
{
    objc_sync_enter(object)
    let result = closure()
    objc_sync_exit(object)
    return result
}

