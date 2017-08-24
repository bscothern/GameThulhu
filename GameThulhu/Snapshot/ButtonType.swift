//
//  ButtonType.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

/// All button types that can be on a `Gamepad`.
/// - Note: These are not all supported on every type of Gamepad.
public enum ButtonType: Hashable {
    /// When considering a `DirectionalPadType` element as 4 buttons these are the directions that can be used to identify them.
    public enum Direction {
        
        /// The up button of the directional pad.
        case up
        
        /// The down button of the directional pad.
        case down
        
        /// The left button of the directional pad.
        case left
        
        /// The right button of the directional pad.
        case right
        
        /// Helper to `ButtonType` so it can get a hashValue for the direction and use it to help identify the dpad elements
        fileprivate var hiddenHashValue: Int {
            return {
                switch self {
                case .up:
                    return 1
                case .down:
                    return 2
                case .left:
                    return 3
                case .right:
                    return 4
                }
            }() * 100
        }
    }
    
    /// The **A** button.
    case buttonA
    
    /// The **B** button.
    case buttonB
    
    /// The **X** button.
    case buttonX
    
    /// The **Y** button.
    case buttonY
    
    /// The **Top Left** trigger.
    case L1
    
    /// The **Bottom Left** trigger.
    case L2
    
    /// The **Top Right** trigger.
    case R1
    
    /// The **Bottom Right** trigger.
    case R2
    
    /// The `Direction` of the **D-Pad** to consider as a button.
    case dPad(direction: Direction)
    
    /// The `Direction` of the **Left Joystick** to consider as a button.
    case leftJoystick(direction: Direction)
    
    /// The `Direction` of the **Right Joystick** to consider as a button.
    case rightJoystick(direction: Direction)
    
    //MARK:- Protocol Conformance
    //MARK: Equatable
    public static func ==(lhs: ButtonType, rhs: ButtonType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    //MARK: Hashable
    public var hashValue: Int {
        switch self {
        case .buttonA:
            return 0
        case .buttonB:
            return 1
        case .buttonX:
            return 2
        case .buttonY:
            return 3
            
        case .L1:
            return 4
        case .L2:
            return 5
        case .R1:
            return 6
        case .R2:
            return 7
            
        case .dPad(let direction):
            return 8 + direction.hiddenHashValue
        case .leftJoystick(let direction):
            return 9 + direction.hiddenHashValue
        case .rightJoystick(let direction):
            return 10 + direction.hiddenHashValue
        }
    }
}
