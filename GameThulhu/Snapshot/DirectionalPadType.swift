//
//  DirectionalPadType.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation


/// All directional pad types that can be on a `Gamepad`.
/// - Note: These are not all supported on every type of `Gamepad`.
public enum DirectionalPadType {
    /// The **D-Pad**
    case dPad
    
    /// The **Left Joystick**
    case leftJoystick
    
    /// The **Right Joystick**
    case rightJoystick
}
