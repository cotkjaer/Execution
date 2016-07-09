//
//  Atomic.swift
//  Execution
//
//  Created by Christian Otkjær on 01/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Blocking Atomic Wrapper

public class Atomic<V>
{
    private var lock = SpinLock()
    private var _value : V
    
    public init(_ value: V)
    {
        _value = value
    }
    
    public var value : V
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
    
    public func with(block: (UnsafeMutablePointer<V>) -> ())
    {
        lock.lock()
        
        block(&_value)
        
        lock.unlock()
    }
}

extension Atomic where V : IntegerArithmeticType, V: IntegerLiteralConvertible
{
    public func increment(delta: V = 1) -> V
    {
        lock.lock()
        defer { lock.unlock() }
        
        _value += delta
        
        return _value
    }
    
    public func decrement(delta: V = 1) -> V
    {
        lock.lock()
        defer { lock.unlock() }
        
        _value -= delta
        
        return _value
    }
    
}


public class NonblockingAtomic<V>
{
    private let queue = SerialQueue(name: NSUUID().UUIDString)
    private var _value : V
    
    public init(_ value: V)
    {
        _value = value
    }
    
    public var value : V
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
    
    public func with(block: (UnsafeMutablePointer<V>) -> ())
    {
        queue.async { block(&self._value) }
    }
}

extension NonblockingAtomic where V : IntegerArithmeticType, V: IntegerLiteralConvertible
{
    public func increment(delta: V = 1) -> V
    {
        var v = _value
        
        queue.sync { self._value += delta; v = self._value }
        
        return v
    }
    
    public func decrement(delta: V = 1) -> V
    {
        var v = _value
        
        queue.sync { self._value -= delta; v = self._value }
        
        return v
    }
    
}
