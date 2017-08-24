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
    
    /// The type of directional pad this is.
    public let type: DirectionalPadType
    
    /// The **up** button on the D-Pad.
    public let up: Button
    
    /// The **down** button on the D-Pad.
    public let down: Button
    
    /// The **left** button on the D-Pad.
    public let left: Button
    
    /// The **right** button on the D-Pad.
    public let right: Button
    
    /// Ranging from `-1.0` (left) to `1.0` (right) depending on the value of the X-Axis on the D-Pad.
    public var xAxis: Float {
        return right.value - left.value
    }
    
    /// Ranging from `-1.0` (down) to `1.0` (up) depending on the value of the Y-Axis on the D-Pad.
    public var yAxis: Float {
        return up.value - down.value
    }
    
    /// The main constructor for a DPad. A DPad represents the state of the D-Pad on a game controller.
    ///
    /// - Parameters:
    ///   - type: The type of directional pad this is.
    ///   - up: The **up** button on the D-Pad.
    ///   - down: The **down** button on the D-Pad.
    ///   - left: The **left** button on the D-Pad.
    ///   - right: The **right** button on the D-Pad.
    public init(type: DirectionalPadType, up: Button, down: Button, left: Button, right: Button) {
        self.type = type
        self.up = up
        self.down = down
        self.left = left
        self.right = right
    }
    
    /// A convenient constructor for a DPad. It uses the default Apple representation and converts it.
    ///
    /// - Parameters:
    ///   - type: The type of directional pad this is.
    ///   - dPad: The `GCControllerDirectionPad` that should be converted.
    public init(type: DirectionalPadType, dPad: GCControllerDirectionPad) {
        self.init(type: type, up: Button(type: .dPad(direction: .up), button: dPad.up), down: Button(type: .dPad(direction: .down), button: dPad.down), left: Button(type: .dPad(direction: .left), button: dPad.left), right: Button(type: .dPad(direction: .right), button: dPad.right))
    }
}

extension DirectionalPad: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "DirectionalPad -\n\tUp: (\(up.debugDescription)\t\t\tDown: (\(down.debugDescription)\n\tLeft: (\(left.debugDescription)\t\tRight: (\(right.debugDescription)\n\txAxis: \(xAxis.format("%0.2"))\t\tyAxis: \(yAxis.format("%0.2"))"
    }
}
