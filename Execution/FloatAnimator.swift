//
//  FloatAnimator.swift
//  Execution
//
//  Created by Christian Otkjær on 04/11/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

open class FloatAnimator
{
    fileprivate let StepSize : Float = 1.0/30.0
    
    fileprivate var tasks = Array<Task>()
    
    var setter : ((Float) -> ())!
    var getter : (() -> Float)!

    public init(setter: @escaping (Float) -> () = { _ in }, getter: @escaping () -> Float = { return 0 })
    {
        self.getter = getter
        self.setter = setter
    }
    
    open func animateFloat(_ to: Float, duration: Double)
    {
        tasks.forEach { $0.unschedule() }
        tasks.removeAll(keepingCapacity: true)
        
        let T = Float(max(0.1, duration))
        let from = getter()
        
        //liniear easing function
        let f = { (t: Float) -> Float in return (from * (T - t) + to * t) / T }
        
        stride(from: T, to: 0, by: -StepSize).forEach { let v = f($0); self.tasks.append(Task(delay: Double($0), closure: { self.setter(v) })) }
    }
}
