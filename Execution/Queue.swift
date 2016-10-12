//
//  Queue.swift
//  Execution
//
//  Created by Christian Otkjær on 30/06/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

//public enum DispatchQueueQualityOfService
//{
//    /// The main queue
//    case main
//    
//    /// The default QoS
//    case `default`
//    
//    /// Use for user-initiated tasks which do NOT involve UI
//    case initiated
//    
//    /// Use for user-initiated tasks which do involve UI
//    case interactive
//    
//    /// Use for tasks not initiated by the user
//    case utility
//    
//    /// Severly low QoS, should only be used when app is not active
//    case background
//    
//    fileprivate var qos_class: qos_class_t
//    {
//        switch self
//        {
//        case .main: return qos_class_main()
//        case .default: return DispatchQoS.QoSClass.default
//        case .initiated: return DispatchQoS.QoSClass.userInitiated
//        case .interactive: return DispatchQoS.QoSClass.userInteractive
//        case .utility: return DispatchQoS.QoSClass.utility
//        case .background: return DispatchQoS.QoSClass.background
//        }
//    }
//    
//    public var queue: Dispatch.DispatchQueue
//    {
//        switch self
//        {
//        case .main: return DispatchQueue.main
//        default: return DispatchQueue.global(qos: qos_class)
//        }
//    }
//}

///// Types to use when creating new dispatch queues.
//public enum DispatchQueueType
//{
//    /// A dispatch queue that executes blocks serially in FIFO order
//    case serial
//    
//    ///A dispatch queue that executes blocks concurrently. Although they execute blocks concurrently, you can use barrier blocks to create synchronization points within the queue
//    case concurrent
//    
//    fileprivate var attribute : Dispatch.DispatchQueue.Attributes
//    {
//        switch self
//        {
//        case .serial : return DispatchQueue.Attributes()
//        case .concurrent : return DispatchQueue.Attributes.concurrent
//        }
//    }
//}

//open class NamedDispatchQueue
//{
//    var dispatch_queue : Dispatch.DispatchQueue
//    
//    fileprivate init(name: String, type: DispatchQueueType, qos: DispatchQueueQualityOfService = .default)
//    {
//        dispatch_queue = DispatchQueue(label: name, attributes: dispatch_queue_attr_make_with_qos_class( type.attribute, qos.qos_class,QOS_MIN_RELATIVE_PRIORITY ))
//    }
//
//    /**
//     Submits `block` for asynchronous execution and returns immediately
//     */
//    func async(_ barrier: Bool = false, block: @escaping ()->())
//    {
//        if barrier
//        {
//            dispatch_queue.async(flags: .barrier, execute: block)
//        }
//        else
//        {
//            dispatch_queue.async(execute: block)
//        }
//    }
//    
//    /** Submits a block for synchronous execution. Does not return until the block has finished.
//     
//     - note: Calling this function in a block already executing on this queue results in deadlock.
//     */
//    func sync(_ barrier: Bool = false, block: ()->())
//    {
//        if barrier
//        {
//            dispatch_queue.sync(flags: .barrier, execute: block)
//        }
//        else
//        {
//            dispatch_queue.sync(execute: block)
//        }
//    }
//    
//    /** Repeats a block `iterations` times
//     
//     - parameter iterations: The number of times to repeat submitting `block`
//     
//     - parameter block : The block to repeat
//     */
//    func apply( _ iterations: Int, block: (Int) -> () )
//    {
//        DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
//    }
//
//}

//open class SerialQueue : NamedDispatchQueue
//{
//    public init(name: String, qos: DispatchQueueQualityOfService = .default)
//    {
//        super.init(name: name, type: DispatchQueueType.serial, qos: qos)
//    }
//}
//
//open class ConcurrentQueue : NamedDispatchQueue
//{
//    public init(name: String, qos: DispatchQueueQualityOfService = .default)
//    {
//        super.init(name: name, type: .concurrent, qos: qos)
//    }
//
//    /**
//     Submits `block` for asynchronous execution and returns immediately
//     
//    - note :
//     Calls to this function always return immediately after the block has been submitted and never wait for the block to be invoked. When the barrier block reaches the front of the queue, it is not executed immediately. Instead, the queue waits until its currently executing blocks finish executing. At that point, the barrier block executes. Any blocks submitted after the barrier-block are not executed until the barrier-block completes.
//     */
//    func async_barrier(_ barrierBlock: @escaping ()->())
//    {
//        dispatch_queue.async(flags: .barrier, execute: barrierBlock)
//    }
//    
//    /** Submits a block for synchronous execution. Does not return until the block has finished.
//     
//     - note: Calling this function in a block already executing on this queue results in deadlock.
//     */
//    func sync_barrier(_ block: ()->())
//    {
//        dispatch_queue.sync(flags: .barrier, execute: block)
//    }
//
//}

//private var queueContextKey = 0
//
//open class DispatchQueue
//{
//    open static let Main = DispatchQueue(queue: DispatchQueue.main)
//
//    fileprivate var queue : Dispatch.DispatchQueue
//
//    fileprivate init(queue: Dispatch.DispatchQueue)
//    {
//        self.queue = queue
//        self.queue.setSpecific(key: /*Migrator FIXME: Use a variable of type DispatchSpecificKey*/ queueContextKey, value: self.queue.context)
//    }
//
//    public convenience init(globalWithQualityOfService qos: DispatchQueueQualityOfService)
//    {
//        self.init(queue: DispatchQueue.global(qos: qos.qos_class))
//    }
//    
//    public convenience init(name: String, type: DispatchQueueType, qos: DispatchQueueQualityOfService)
//    {
//        self.init(queue: DispatchQueue(label: name, attributes: dispatch_queue_attr_make_with_qos_class( type.attribute, qos.qos_class,QOS_MIN_RELATIVE_PRIORITY )))
//    }
//    
//    /**
//     Submits `block` for asynchronous execution and returns immediately
//     */
//    public final func async(_ block: @escaping ()->())
//    {
//        queue.async(execute: block)
//    }
//    
//    /** Submits a block for synchronous execution. Does not return until the block has finished.
//     
//     - note: Calling this function in a block already executing on this queue results in the block executing immediately.
//     */
//    public final func sync(_ block: () -> ())
//    {
//        if isSameQueue()
//        {
//            return block()
//        }
//        else
//        {
//            queue.sync(execute: block)
//        }
//    }
//    
//    /**
//     Returns `true` if the current execution context is synchronized with
//     the `serialQueue`.
//     */
//    fileprivate final func isSameQueue() -> Bool
//    {
//        return DispatchQueue.getSpecific(&queueContextKey) == queue.context
//    }
//    
//    /** Repeats a block `iterations` times
//     
//    - parameter iterations: The number of times to repeat submitting `block`
//     
//    - parameter block : The block to repeat
//     */
//    public final func apply( _ iterations: Int, block: (Int) -> () )
//    {
//        DispatchQueue.concurrentPerform(iterations: iterations, execute: block)
//    }
//}

// MARK: - Context

//extension Dispatch.DispatchQueue
//{
//    var context : UnsafeMutableRawPointer { return UnsafeMutableRawPointer(Unmanaged<Dispatch.DispatchQueue>.passUnretained(self).toOpaque()) }
//}
