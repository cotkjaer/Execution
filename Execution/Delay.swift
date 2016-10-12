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
    case by(TimeInterval)
    case until(Date)
}

internal extension Delay
{
    var seconds: TimeInterval
    {
        switch self
        {
        case .by(let seconds):
            return seconds
            
        case .until(let date):
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
        case .by(let seconds):
            return "Delay for \(seconds) seconds"
            
        case .until(let date):
            return "Delay until \(DateFormatter().string(from: date)) \(seconds) seconds"
        }
    }
}

