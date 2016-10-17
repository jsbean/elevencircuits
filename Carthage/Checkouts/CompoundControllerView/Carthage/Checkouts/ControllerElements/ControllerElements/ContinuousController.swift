//
//  ContinuousController.swift
//  ControllerElements
//
//  Created by James Bean on 9/19/16.
//
//

public protocol ContinuousController {
    
    func ramp(to newValue: Float, over duration: Double)
}
