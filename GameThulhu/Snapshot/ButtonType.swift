//
//  ButtonType.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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
