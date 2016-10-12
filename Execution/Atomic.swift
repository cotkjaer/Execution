//
//  Atomic.swift
//  Execution
//
//  Created by Christian Otkjær on 01/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Blocking Atomic Wrapper

open class Atomic<V>
{
    fileprivate var lock = SpinLock()
    fileprivate var _value : V
    
    public init(_ value: V)
    {
        _value = value
    }
    
    open var value : V
        {
        get
        {
            lock.lock()
            defer { lock.unlock() }
            
            return _value
        }
        
        set
        {
            lock.lock()
            defer { lock.unlock() }
            
            _value = newValue
        }
    }
    
    open func with(_ block: (UnsafeMutablePointer<V>) -> ())
    {
        lock.lock()
        
        block(&_value)
        
        lock.unlock()
    }
}

extension Atomic where V : IntegerArithmetic, V: ExpressibleByIntegerLiteral
{
    public func increment(_ delta: V = 1) -> V
    {
        lock.lock()
        defer { lock.unlock() }
        
        _value += delta
        
        return _value
    }
    
    public func decrement(_ delta: V = 1) -> V
    {
        lock.lock()
        defer { lock.unlock() }
        
        _value -= delta
        
        return _value
    }
    
}


open class NonblockingAtomic<V>
{
    fileprivate let queue = DispatchQueue(label: "UUID().uuidString", qos: .userInteractive)// SerialQueue(name: UUID().uuidString)
    fileprivate var _value : V
    
    public init(_ value: V)
    {
        _value = value
    }
    
    open var value : V
        {
        get
        {
            var v = _value
            
            queue.sync { v = self._value }
            
            return v
        }
        
        set
        {
            queue.async { self._value = newValue }
        }
    }
    
    open func with(_ block: @escaping (UnsafeMutablePointer<V>) -> ())
    {
        queue.async { block(&self._value) }
    }
}

extension NonblockingAtomic where V : IntegerArithmetic, V: ExpressibleByIntegerLiteral
{
    public func increment(_ delta: V = 1) -> V
    {
        var v = _value
        
        queue.sync { self._value += delta; v = self._value }
        
        return v
    }
    
    public func decrement(_ delta: V = 1) -> V
    {
        var v = _value
        
        queue.sync { self._value -= delta; v = self._value }
        
        return v
    }
    
}
