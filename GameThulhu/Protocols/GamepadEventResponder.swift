//
//  GamepadEventResponder.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import UIKit

/// The protocol that defines the UIResponder chain for Gamepads.
public protocol GamepadEventResponder {
    //MARK:- Funcs
    
    /// The function that is called on the UIResponder chain when a gamepad has its pause button pressed.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadPausePressed(gamepad)
    ///
    /// - Parameter gamepad: The `Gamepad` that had its pause button pressed.
    func gamepadPausePressed(_ gamepad: Gamepad)
    
    /// The function that is called on the UIResponder chain when a gamepad button is first modified and leaves its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadButtonPressBegan(gamepad, button)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    func gamepadButtonPressBegan(_ gamepad: Gamepad, _ button: Button)
    
    /// The function that is called on the UIResponder chain when a gamepad button is being modified.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadButtonPressChanged(gamepad, button)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    func gamepadButtonPressChanged(_ gamepad: Gamepad,_ button: Button)
    
    /// The function that is called on the UIResponder chain when a gamepad button is done being modified and is back at its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadButtonPressEnded(gamepad, button)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    func gamepadButtonPressEnded(_ gamepad: Gamepad,_ button: Button)
    
    /// The function that is called on the UIResponder chain when a gamepad directional pad is first modified and leaves its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadDirectionalPadMovementBegan(gamepad, dPad)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified directional pad.
    ///   - dPad: The `DirectionalPad` that has been modified.
    func gamepadDirectionalPadMovementBegan(_ gamepad: Gamepad, _ dPad: DirectionalPad)
    
    /// The function that is called on the UIResponder chain when a gamepad directional pad is being modified.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadDirectionalPadChanged(gamepad, dPad)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified directional pad.
    ///   - dPad: The `DirectionalPad` that has been modified.
    func gamepadDirectionalPadChanged(_ gamepad: Gamepad, _ dPad: DirectionalPad)
    
    /// The function that is called on the UIResponder chain when a gamepad directional pad is done being modified and is back at its resting position.
    ///
    /// - Important: If you want this event to continue up the UIResponder chain you must call
    ///
    ///       next?.gamepadDirectionalPadMovementEnded(gamepad, dPad)
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified directional pad.
    ///   - dPad: The `DirectionalPad` that has been modified.
    func gamepadDirectionalPadMovementEnded(_ gamepad: Gamepad, _ dPad: DirectionalPad)
}

//MARK:- Default Implementation
// These functions just pass the events up the UIResponder chain.
extension UIResponder: GamepadEventResponder {
    open func gamepadPausePressed(_ gamepad: Gamepad) {
        next?.gamepadPausePressed(gamepad)
    }
    
    open func gamepadButtonPressBegan(_ gamepad: Gamepad,_ button: Button) {
        next?.gamepadButtonPressBegan(gamepad, button)
    }
    
    open func gamepadButtonPressChanged(_ gamepad: Gamepad,_ button: Button) {
        next?.gamepadButtonPressChanged(gamepad, button)
    }
    
    open func gamepadButtonPressEnded(_ gamepad: Gamepad,_ button: Button) {
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
