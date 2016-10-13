//
//  Semaphore.swift
//  Execution
//
//  Created by Christian Otkjær on 30/06/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

extension DispatchSemaphore
{
    public func execute(timeout: DispatchTime = DispatchTime.now(), closure: () -> ()) -> DispatchTimeoutResult
    {
        guard wait(timeout: timeout) == .success else { return .timedOut }
        
        closure()
        
        signal()
        
        return .success
    }
}
