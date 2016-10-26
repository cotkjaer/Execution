//
//  NSBlockOperation+Completion.swift
//  Execution
//
//  Created by Christian Otkjær on 09/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Completion

extension BlockOperation
{
    public convenience init(block: @escaping () -> (), completion: ((_ cancelled: Bool) -> ())?)
    {
        self.init(block: block)
        completionBlock = { completion?(self.isCancelled) }
    }
}

extension OperationQueue
{
    public func addOperationWithBlock(_ block: @escaping () -> (), completion: ((_ cancelled: Bool) -> ())?)
    {
        addOperation(BlockOperation(block: block, completion: completion))
    }
}

