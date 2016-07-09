//
//  Delay.swift
//  Execution
//
//  Created by Christian Otkjær on 08/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

public enum Delay
{
    case By(NSTimeInterval)
    case Until(NSDate)
}

internal extension Delay
{
    var seconds: NSTimeInterval
    {
        switch self
        {
        case .By(let seconds):
            return seconds
            
        case .Until(let date):
            return max ( 0, date.timeIntervalSinceNow )
        }
    }
}

extension Delay: CustomStringConvertible
{
    public var description: String
    {
        switch self
        {
        case .By(let seconds):
            return "Delay for \(seconds) seconds"
            
        case .Until(let date):
            return "Delay until \(NSDateFormatter().stringFromDate(date)) \(seconds) seconds"
        }
    }
}

