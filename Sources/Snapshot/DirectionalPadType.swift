//
//  DirectionalPadType.swift
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

/// All directional pad types that can be on a `Gamepad`.
/// - Note: These are not all supported on every type of `Gamepad`.
@objc public enum DirectionalPadType: Int {

    /// The **D-Pad**
    case dPad

    /// The **Left Joystick**
    case leftJoystick

    /// The **Right Joystick**
    case rightJoystick
}

internal extension DirectionalPadType {
    //MARK:- Types

    /// A convenience enum to help bridge DirectionalPadType to ButtonType
    enum Direction {

        /// The **Up** direction on a D-Pad.
        case up

        /// The **Down** direction on a D-Pad.
        case down

        /// The **Left** direction on a D-Pad.
        case left

        /// The **Right** direction on a D-Pad.
        case right
    }

    //MARK:- Funcs

    /// Brdige a `DirectionalPadType` into the correct `ButtonType` with the direction desired.
    ///
    /// - Parameter direction: A `DirectionalPadType.Direction` that relates to the `DirectionalPadType` direction that is desired.
    /// - Returns: A `ButtonType` that is in the given direction.
    func asButton(direction: Direction) -> ButtonType {
        switch self {
        case .dPad:
            switch direction {
            case .up:
                return .dPadUpDirection
            case .down:
                return .dPadDownDirection
            case .left:
                return .dPadLeftDirection
            case .right:
                return .dPadRightDirection
            }
        case .leftJoystick:
            switch direction {
            case .up:
                return .leftJoystickUpDirection
            case .down:
                return .leftJoystickDownDirection
            case .left:
                return .leftJoystickLeftDirection
            case .right:
                return .leftJoystickRightDirection
            }
        case .rightJoystick:
            switch direction {
            case .up:
                return .rightJoystickUpDirection
            case .down:
                return .rightJoystickDownDirection
            case .left:
                return .rightJoystickLeftDirection
            case .right:
                return .rightJoystickRightDirection
            }
        }
    }
}
