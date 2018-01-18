//
//  UIResponder.swift
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

internal extension UIResponder {
    //MARK:- Types
    /// An event wrapper for pause button events so they can be passed into `UIApplication.sendAction(_:to:from:for:)` as the sender to the function the UIResponder chain can handle it.
    class PauseEvent {
        /// The `Gamepad` which has had its pause button pressed.
        let gamepad: Gamepad

        /// Create a `PauseEvent` to pass as the sender in `UIApplication.sendAction(_:to:from:for:)`.
        ///
        /// - Parameter gamepad: The `Gamepad` which has had its pause button pressed.
        init(gamepad: Gamepad) {
            self.gamepad = gamepad
        }
    }

    /// An event wrapper for `Button` structs so they can be passed into `UIApplication.sendAction(_:to:from:for:)` as the sender to the function so the values can be used to call the correct callback on the UIResponder chain.
    class ButtonEvent {
        let gamepad: Gamepad
        let button: Button
        let callbackType: ButtonCallbackType

        /// Create a `ButtonEvent` to pass as the sender in `UIApplication.sendAction(_:to:from:for:)`.
        ///
        /// - Parameters:
        ///   - gamepad: The `Gamepad` that owns the `button`.
        ///   - button: The `Button` that has changed.
        ///   - callbackType: The callback function type that should be called on the default UIResponder chain.
        init(gamepad: Gamepad, button: Button, callbackType: ButtonCallbackType) {
            self.gamepad = gamepad
            self.button = button
            self.callbackType = callbackType
        }
    }

    /// An event wrapper for `DirectionalPad` structs so they can be passed into `UIApplication..sendAction(_:to:from:for:)` as the sender to the function so the values can be used to call the correct callback on the UIResponder chain.
    class DirectionalPadEvent {

        /// The `Gamepad` that owns the `dPad`.
        let gamepad: Gamepad

        /// The `DirectionalPad` that has changed.
        let dPad: DirectionalPad

        /// The callback function type that should be called on the UIResponder chain.
        let callbackType: DirectionalPadCallbackType

        /// Create a `DirectionalPadEvent` to pass as the sender in `UIApplication.sendAction(_:to:from:for:)`.
        ///
        /// - Parameters:
        ///   - gamepad: The `Gamepad` that owns the `dPad`.
        ///   - dPad: The `DirectionalPad` that has changed.
        ///   - callbackType: The callback function type that should be called on the default UIResponder chain.
        init(gamepad: Gamepad, dPad: DirectionalPad, callbackType: DirectionalPadCallbackType) {
            self.gamepad = gamepad
            self.dPad = dPad
            self.callbackType = callbackType
        }
    }

    //MARK:- Event Raisers

    /// Puts a callback for a pause button event on the default UIResponder chain.
    ///
    /// - Parameter gamepad: The `Gamepad` that has had its pause button pressed.
    @inline(__always) static func raiseGamepadPauseEvent(gamepad: Gamepad) {
        UIApplication.shared.sendAction(#selector(handlePauseEvent(sender:)), to: nil, from: PauseEvent(gamepad: gamepad), for: nil)
    }

    /// Puts a callback for a `Button` onto the default UIResponder chain.
    ///
    /// - Parameters:
    ///   - gamepad: This `Gamepad` that owns the `button`.
    ///   - button: The `Button` that has had its state change and needs to have an event raised on the UIResponder chain.
    ///   - callbackType: The callback function type that should take place on the UIResponder chain.
    @inline(__always) static func raiseGamepadEvent(gamepad: Gamepad, button: Button, callbackType: ButtonCallbackType) {
        UIApplication.shared.sendAction(#selector(handleButtonEvent(sender:)), to: nil, from: ButtonEvent(gamepad: gamepad, button: button, callbackType: callbackType), for: nil)
    }

    /// Puts a callback for a `DirectionalPad` onto the default UIResponder chain.
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that owns the `dPad`.
    ///   - dPad: The `DirectionalPad` that has had its state change and needs to have an event raised on the UIResponder chain.
    ///   - callbackType: The callback function type that should take place on the UIResponder chain.
    @inline(__always) static func raiseGamepadEvent(gamepad: Gamepad, dPad: DirectionalPad, callbackType: DirectionalPadCallbackType) {
        UIApplication.shared.sendAction(#selector(handleDirectionalPadEvent(sender:)), to: nil, from: DirectionalPadEvent(gamepad: gamepad, dPad: dPad, callbackType: callbackType), for: nil)
    }

    //MARK:- Event Handlers

    /// This function starts the UIResponder chain execution for a pause button event.
    ///
    /// - Important: This function should not be directly called. It needs to be called via `UIApplication.shared.sendAction(_:to:from:for:)` with the `target` as `nil` in order for it to execute on the default UIResponder chain.
    ///
    /// - Parameter sender: The object that needs the UIResponder chain to act upon it. This should be a `PauseEvent`, if it is not then the function will instantly return with no actions taken.
    @objc func handlePauseEvent(sender: AnyObject) {
        guard let pauseEvent = (sender as? PauseEvent) else {
            return
        }
        gamepadPausePressed(pauseEvent.gamepad)
    }

    /// This function starts the UIResponder chain execution for a `Button` event.
    ///
    /// - Important: This function should not be directly called. It needs to be called via `UIApplication.shared.sendAction(_:to:from:for:)` with the `target` as `nil` in order for it to execute on the default UIResponder chain.
    ///
    /// - Parameter sender: The object that needs the UIResponder chain to act upon it. This should be a `ButtonEvent`, if it is not then the function will instantly return with no actions taken.
    @objc func handleButtonEvent(sender: AnyObject) {
        guard let buttonEvent = (sender as? ButtonEvent) else {
            return
        }
        switch buttonEvent.callbackType {
        case .began:
            gamepadButtonPressBegan(buttonEvent.gamepad, buttonEvent.button)
        case .changed:
            gamepadButtonPressChanged(buttonEvent.gamepad, buttonEvent.button)
        case .ended:
            gamepadButtonPressEnded(buttonEvent.gamepad, buttonEvent.button)
        }
    }

    /// This function starts the UIResponder chain execution for a `DirectionalPad` event.
    ///
    /// - Important: This function should not be directly called. It needs to be called via `UIApplication.shared.sendAction(_:to:from:for:)` with the`target` as `nil` in order for it to execute on the default UIResponder chain.
    ///
    /// - Parameter sender: The object that needs the UIResponder chain to act upon it. This should be a `DirectionalPadEvent`, if it is not then the function will instantly return with no actions taken.
    @objc func handleDirectionalPadEvent(sender: AnyObject) {
        let dPadEvent = (sender as! DirectionalPadEvent)
        switch dPadEvent.callbackType {
        case .began:
            gamepadDirectionalPadMovementBegan(dPadEvent.gamepad, dPadEvent.dPad)
        case .changed:
            gamepadDirectionalPadChanged(dPadEvent.gamepad, dPadEvent.dPad)
        case .ended:
            gamepadDirectionalPadMovementEnded(dPadEvent.gamepad, dPadEvent.dPad)
        }
    }
}
