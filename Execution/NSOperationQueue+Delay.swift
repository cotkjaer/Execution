//
//  NSOperation+Delay.swift
//  Execution
//
//  Created by Christian Otkjær on 08/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Delay

extension NSOperationQueue
{
    /** Adds `operation` to queue, but delays the operation `delay` seconds
    - parameter operation : The `NSOperation` to add
    - parameter delay : the number of seconds to delay the operation
    - 
 */
    public func addOperation(operation: NSOperation, withDelay seconds: Double)
    {
        if let delayOperation = SimpleDelayOperation(seconds: seconds)
        {
            operation.addDependency(delayOperation)
            
            addOperations([delayOperation, operation], waitUntilFinished: false)
        }
        else
        {
            addOperation(operation)
        }
    }
}

// MARK: - DelayOperation

private class SimpleDelayOperation : NSOperation
{
    let seconds : Double
    
    init?(seconds: Double)
    {
        guard seconds > 0 else { return nil }
        
        self.seconds = seconds
    }
    
    final override var asynchronous : Bool  { return false }

    final override func main()
    {
        let s : useconds_t = useconds_t(seconds * 1_000_000)
        usleep(s)
//        sleep(seconds)
    }
}
