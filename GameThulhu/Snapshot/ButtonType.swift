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
@objc public enum ButtonType: Int {
    
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
    
    /// The **Up** direction on the **D-Pad**.
    case dPadUpDirection
    
    /// The **Down** direction on the **D-Pad**.
    case dPadDownDirection
    
    /// The **Left** direction on the **D-Pad**.
    case dPadLeftDirection
    
    /// The **Right** direction on the **D-Pad**.
    case dPadRightDirection
    
    /// The **Up** direction on the **Left Joystick**.
    case leftJoystickUpDirection
    
    /// The **Down** direction ont the **Left Joystick**.
    case leftJoystickDownDirection
    
    /// The **Left** direction on the **Left Joystick**.
    case leftJoystickLeftDirection
    
    /// The **Right** direction on the **Left Joystick**.
    case leftJoystickRightDirection
    
    /// The **Up** direction on the **Right Joystick**.
    case rightJoystickUpDirection
    
    /// The **Down** direction on the **Right Joystick**.
    case rightJoystickDownDirection
    
    /// The **Left** direction on the **Right Joystick**.
    case rightJoystickLeftDirection
    
    /// The **Right** direction on the **Right Joystick**.
    case rightJoystickRightDirection
}
