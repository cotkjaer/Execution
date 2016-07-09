//
//  NSBlockOperation+Completion.swift
//  Execution
//
//  Created by Christian Otkjær on 09/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Completion

extension NSBlockOperation
{
    public convenience init(block: () -> (), completion: ((cancelled: Bool) -> ())?)
    {
        self.init(block: block)
        completionBlock = { completion?(cancelled: self.cancelled) }
    }
}

// MARK: - <#comment#>

extension NSOperationQueue
{
    public func addOperationWithBlock(block: () -> (), completion: ((cancelled: Bool) -> ())?)
    {
        addOperation(NSBlockOperation(block: block, completion: completion))
    }
}

