//
//  GamepadEventResponder.swift
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

import UIKit

/// The protocol that defines the UIResponder chain for Gamepads.
///
/// - Important:
///     In order for this protocol to work you must have a first reponder on the UIResponder chain.
///     To ensure that there is one you should have the following added to your UIViewController:
///
///       override var canBecomeFirstResponder: Bool {
///           return true
///       }
///
///     You **must** also make sure you call `becomeFirstResponder()` and `resignFirstResponder()` in
///     `UIViewController.viewWillAppear(_:)` and `UIViewController.viewWillDisappear(_:)` respectively.
///
///     If you do all of these things the responder chain will work and the events will happen as expected.
@objc public protocol GamepadEventResponder {
    //MARK:- Funcs

    /// The function that is called on the UIResponder chain when a gamepad has its pause button pressed.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadPausePressed(gamepad)
    ///
    /// - Parameter gamepad: The `Gamepad` that had its pause button pressed.
    @objc optional func gamepadPausePressed(_ gamepad: Gamepad)

    /// The function that is called on the UIResponder chain when a gamepad button is first modified and leaves its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadButtonPressBegan(gamepad, button)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    @objc optional func gamepadButtonPressBegan(_ gamepad: Gamepad, _ button: Button)

    /// The function that is called on the UIResponder chain when a gamepad button is being modified.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadButtonPressChanged(gamepad, button)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    @objc optional func gamepadButtonPressChanged(_ gamepad: Gamepad, _ button: Button)

    /// The function that is called on the UIResponder chain when a gamepad button is done being modified and is back at its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadButtonPressEnded(gamepad, button)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    @objc optional func gamepadButtonPressEnded(_ gamepad: Gamepad, _ button: Button)

    /// The function that is called on the UIResponder chain when a gamepad directional pad is first modified and leaves its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadDirectionalPadMovementBegan(gamepad, dPad)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified directional pad.
    ///   - dPad: The `DirectionalPad` that has been modified.
    @objc optional func gamepadDirectionalPadMovementBegan(_ gamepad: Gamepad, _ dPad: DirectionalPad)

    /// The function that is called on the UIResponder chain when a gamepad directional pad is being modified.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadDirectionalPadChanged(gamepad, dPad)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified directional pad.
    ///   - dPad: The `DirectionalPad` that has been modified.
    @objc optional func gamepadDirectionalPadChanged(_ gamepad: Gamepad, _ dPad: DirectionalPad)

    /// The function that is called on the UIResponder chain when a gamepad directional pad is done being modified and is back at its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadDirectionalPadMovementEnded(gamepad, dPad)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified directional pad.
    ///   - dPad: The `DirectionalPad` that has been modified.
    @objc optional func gamepadDirectionalPadMovementEnded(_ gamepad: Gamepad, _ dPad: DirectionalPad)
}

//MARK:- Default Implementation
// These functions just pass the events up the UIResponder chain.
extension UIResponder: GamepadEventResponder {
    open func gamepadPausePressed(_ gamepad: Gamepad) {
        next?.gamepadPausePressed(gamepad)
    }

    open func gamepadButtonPressBegan(_ gamepad: Gamepad, _ button: Button) {
        next?.gamepadButtonPressBegan(gamepad, button)
    }

    open func gamepadButtonPressChanged(_ gamepad: Gamepad, _ button: Button) {
        next?.gamepadButtonPressChanged(gamepad, button)
    }

    open func gamepadButtonPressEnded(_ gamepad: Gamepad, _ button: Button) {
        next?.gamepadButtonPressEnded(gamepad, button)
    }

    open func gamepadDirectionalPadMovementBegan(_ gamepad: Gamepad, _ dPad: DirectionalPad) {
        next?.gamepadDirectionalPadMovementBegan(gamepad, dPad)
    }

    open func gamepadDirectionalPadChanged(_ gamepad: Gamepad, _ dPad: DirectionalPad) {
        next?.gamepadDirectionalPadChanged(gamepad, dPad)
    }

    open func gamepadDirectionalPadMovementEnded(_ gamepad: Gamepad, _ dPad: DirectionalPad) {
        next?.gamepadDirectionalPadMovementEnded(gamepad, dPad)
    }
}
