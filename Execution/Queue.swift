//
//  Queue.swift
//  Execution
//
//  Created by Christian Otkjær on 30/06/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

public enum DispatchQueueQualityOfService
{
    /// The main queue
    case Main
    
    /// The default QoS
    case Default
    
    /// Use for user-initiated tasks which do NOT involve UI
    case Initiated
    
    /// Use for user-initiated tasks which do involve UI
    case Interactive
    
    /// Use for tasks not initiated by the user
    case Utility
    
    /// Severly low QoS, should only be used when app is not active
    case Background
    
    private var qos_class: qos_class_t
    {
        switch self
        {
        case .Main: return qos_class_main()
        case .Default: return QOS_CLASS_DEFAULT
        case .Initiated: return QOS_CLASS_USER_INITIATED
        case .Interactive: return QOS_CLASS_USER_INTERACTIVE
        case .Utility: return QOS_CLASS_UTILITY
        case .Background: return QOS_CLASS_BACKGROUND
        }
    }
    
    public var queue: dispatch_queue_t
    {
        switch self
        {
        case .Main: return dispatch_get_main_queue()
        default: return dispatch_get_global_queue(qos_class, 0)
        }
    }
}

/// Types to use when creating new dispatch queues.
public enum DispatchQueueType
{
    /// A dispatch queue that executes blocks serially in FIFO order
    case Serial
    
    ///A dispatch queue that executes blocks concurrently. Although they execute blocks concurrently, you can use barrier blocks to create synchronization points within the queue
    case Concurrent
    
    private var attribute : dispatch_queue_attr_t
    {
        switch self
        {
        case .Serial : return DISPATCH_QUEUE_SERIAL
        case .Concurrent : return DISPATCH_QUEUE_CONCURRENT
        }
    }
}

public class NamedDispatchQueue
{
    var dispatch_queue : dispatch_queue_t
    
    private init(name: String, type: DispatchQueueType, qos: DispatchQueueQualityOfService = .Default)
    {
        dispatch_queue = dispatch_queue_create(name, dispatch_queue_attr_make_with_qos_class( type.attribute, qos.qos_class,QOS_MIN_RELATIVE_PRIORITY ))
    }

    /**
     Submits `block` for asynchronous execution and returns immediately
     */
    func async(barrier: Bool = false, block: ()->())
    {
        if barrier
        {
            dispatch_barrier_async(dispatch_queue, block)
        }
        else
        {
            dispatch_async(dispatch_queue, block)
        }
    }
    
    /** Submits a block for synchronous execution. Does not return until the block has finished.
     
     - note: Calling this function in a block already executing on this queue results in deadlock.
     */
    func sync(barrier: Bool = false, block: ()->())
    {
        if barrier
        {
            dispatch_barrier_sync(dispatch_queue, block)
        }
        else
        {
            dispatch_sync(dispatch_queue, block)
        }
    }
    
    /** Repeats a block `iterations` times
     
     - parameter iterations: The number of times to repeat submitting `block`
     
     - parameter block : The block to repeat
     */
    func apply( iterations: Int, block: Int -> () )
    {
        dispatch_apply(iterations, dispatch_queue, block)
    }

}

public class SerialQueue : NamedDispatchQueue
{
    public init(name: String, qos: DispatchQueueQualityOfService = .Default)
    {
        super.init(name: name, type: DispatchQueueType.Serial, qos: qos)
    }
}

public class ConcurrentQueue : NamedDispatchQueue
{
    public init(name: String, qos: DispatchQueueQualityOfService = .Default)
    {
        super.init(name: name, type: .Concurrent, qos: qos)
    }

    /**
     Submits `block` for asynchronous execution and returns immediately
     
    - note :
     Calls to this function always return immediately after the block has been submitted and never wait for the block to be invoked. When the barrier block reaches the front of the queue, it is not executed immediately. Instead, the queue waits until its currently executing blocks finish executing. At that point, the barrier block executes. Any blocks submitted after the barrier-block are not executed until the barrier-block completes.
     */
    func async_barrier(barrierBlock: ()->())
    {
        dispatch_barrier_async(dispatch_queue, barrierBlock)
    }
    
    /** Submits a block for synchronous execution. Does not return until the block has finished.
     
     - note: Calling this function in a block already executing on this queue results in deadlock.
     */
    func sync_barrier(block: ()->())
    {
        dispatch_barrier_sync(dispatch_queue, block)
    }

}

private var queueContextKey = 0

public class DispatchQueue
{
    public static let Main = DispatchQueue(queue: dispatch_get_main_queue())

    private var queue : dispatch_queue_t

    private init(queue: dispatch_queue_t)
    {
        self.queue = queue
        dispatch_queue_set_specific(self.queue, &queueContextKey, self.queue.context, nil)
    }

    public convenience init(globalWithQualityOfService qos: DispatchQueueQualityOfService)
    {
        self.init(queue: dispatch_get_global_queue(qos.qos_class, 0))
    }
    
    public convenience init(name: String, type: DispatchQueueType, qos: DispatchQueueQualityOfService)
    {
        self.init(queue: dispatch_queue_create(name, dispatch_queue_attr_make_with_qos_class( type.attribute, qos.qos_class,QOS_MIN_RELATIVE_PRIORITY )))
    }
    
    /**
     Submits `block` for asynchronous execution and returns immediately
     */
    public final func async(block: ()->())
    {
        dispatch_async(queue, block)
    }
    
    /** Submits a block for synchronous execution. Does not return until the block has finished.
     
     - note: Calling this function in a block already executing on this queue results in the block executing immediately.
     */
    public final func sync(block: () -> ())
    {
        if isSameQueue()
        {
            return block()
        }
        else
        {
            dispatch_sync(queue, block)
        }
    }
    
    /**
     Returns `true` if the current execution context is synchronized with
     the `serialQueue`.
     */
    private final func isSameQueue() -> Bool
    {
        return dispatch_get_specific(&queueContextKey) == queue.context
    }
    
    /** Repeats a block `iterations` times
     
    - parameter iterations: The number of times to repeat submitting `block`
     
    - parameter block : The block to repeat
     */
    public final func apply( iterations: Int, block: Int -> () )
    {
        dispatch_apply(iterations, queue, block)
    }
}

// MARK: - Context

extension dispatch_queue_t
{
    var context : UnsafeMutablePointer<Void> { return UnsafeMutablePointer<Void>(Unmanaged<dispatch_queue_t>.passUnretained(self).toOpaque()) }
}
