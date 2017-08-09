//
//  DirectionalPad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// This struct represents the state of the D-Pad on a game controller device.
public struct DirectionalPad {
    
    /// The **up** button on the D-Pad.
    public let up: Button
    
    /// The **down** button on the D-Pad.
    public let down: Button
    
    /// The **left** button on the D-Pad.
    public let left: Button
    
    /// The **right** button on the D-Pad.
    public let right: Button
    
    /// Ranging from -1 (left) to 1 (right) depending on the value of the X-Axis on the D-Pad.
    public var xAxis: Float {
        return right.value - left.value
    }
    
    /// Ranging from -1 (down) to 1 (up) depending on the value of the Y-Axis on the D-Pad.
    public var yAxis: Float {
        return up.value - down.value
    }
    
    /**
     The main constructor for a DPad. A DPad represents the state of the D-Pad on a game controller.
     
     - parameters:
         - up: The up button on the D-Pad.
         - down: The down button on the D-Pad.
         - left: The left button on the D-Pad.
         - right: The right button on the D-Pad.
     */
    public init(up: Button, down: Button, left: Button, right: Button) {
        self.up = up
        self.down = down
        self.left = left
        self.right = right
    }
    
    /**
     A convenient constructor for a DPad. It uses the default Apple representation and converts it.
     - parameters:
         - dpad: The dpad that should be converted.
     */
    public init(_ dpad: GCControllerDirectionPad) {
        self.init(up: Button(dpad.up), down: Button(dpad.down), left: Button(dpad.left), right: Button(dpad.right))
    }
}

extension DirectionalPad: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "DirectionalPad -\n\tUp: (\(up.debugDescription)\t\t\tDown: (\(down.debugDescription)\n\tLeft: (\(left.debugDescription)\t\tRight: (\(right.debugDescription)\n\txAxis: \(xAxis.format("%0.2"))\t\tyAxis: \(yAxis.format("%0.2"))"
    }
}
