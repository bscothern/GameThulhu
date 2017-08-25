//
//  GamepadEventResponder.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import UIKit

public protocol GamepadEventResponder {
    //MARK:- Funcs
    
    /// The function that is called on the UIResponder chain when a gamepad has its pause button pressed.
    ///
    /// - Parameter gamepad: The `Gamepad` that had its pause button pressed.
    func gamepadPausePressed(_ gamepad: Gamepad)
    
    /// The function that is called on the UIResponder chain when a gamepad button is first modified and leaves its resting position.
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    func gamepadButtonPressBegan(_ gamepad: Gamepad, _ button: Button)
    
    /// The function that is called on the UIResponder chain when a gamepad button is being modified.
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    func gamepadButtonPressChanged(_ gamepad: Gamepad,_ button: Button)
    
    /// The function that is called on the UIResponder chain when a gamepad button is done being modified and going back to its resting position.
    ///
    /// - Parameters:
    ///   - gamepad: The `Gamepad` that has the modified button.
    ///   - button: The `Button` that has been modifed.
    func gamepadButtonPressEnded(_ gamepad: Gamepad,_ button: Button)
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - gamepad: <#gamepad description#>
    ///   - dPad: <#dPad description#>
    func gamepadDirectionalPadMovementBegan(_ gamepad: Gamepad, _ dPad: DirectionalPad)
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - gamepad: <#gamepad description#>
    ///   - dPad: <#dPad description#>
    func gamepadDirectionalPadChanged(_ gamepad: Gamepad, _ dPad: DirectionalPad)
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - gamepad: <#gamepad description#>
    ///   - dPad: <#dPad description#>
    func gamepadDirectionalPadMovementEnded(_ gamepad: Gamepad, _ dPad: DirectionalPad)
}

//MARK:- Default Implementation
// These functions just pass the events up the UIResponder chain.
extension UIResponder: GamepadEventResponder {
    public func gamepadPausePressed(_ gamepad: Gamepad) {
        next?.gamepadPausePressed(gamepad)
    }
    
    public func gamepadButtonPressBegan(_ gamepad: Gamepad,_ button: Button) {
        next?.gamepadButtonPressBegan(gamepad, button)
    }
    
    public func gamepadButtonPressChanged(_ gamepad: Gamepad,_ button: Button) {
        next?.gamepadButtonPressChanged(gamepad, button)
    }
    
    public func gamepadButtonPressEnded(_ gamepad: Gamepad,_ button: Button) {
        next?.gamepadButtonPressEnded(gamepad, button)
    }
    
    public func gamepadDirectionalPadMovementBegan(_ gamepad: Gamepad, _ dPad: DirectionalPad) {
        next?.gamepadDirectionalPadMovementBegan(gamepad, dPad)
    }
    
    public func gamepadDirectionalPadChanged(_ gamepad: Gamepad, _ dPad: DirectionalPad) {
        next?.gamepadDirectionalPadChanged(gamepad, dPad)
    }
    
    public func gamepadDirectionalPadMovementEnded(_ gamepad: Gamepad, _ dPad: DirectionalPad) {
        next?.gamepadDirectionalPadMovementEnded(gamepad, dPad)
    }
}
