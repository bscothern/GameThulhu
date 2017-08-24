//
//  EventResponder.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import UIKit

public protocol EventResponder {
    //MARK:- Funcs
    func gamepadPausePressed(_ gamepad: Gamepad)
    
    func gamepadButtonPressBegan(_ gamepad: Gamepad, _ button: Button)
    func gamepadButtonPressChanged(_ gamepad: Gamepad,_ button: Button)
    func gamepadButtonPressEnded(_ gamepad: Gamepad,_ button: Button)
    
    func gamepadDirectionalPadMovementBegan(_ gamepad: Gamepad, _ dPad: DirectionalPad)
    func gamepadDirectionalPadChanged(_ gamepad: Gamepad, _ dPad: DirectionalPad)
    func gamepadDirectionalPadMovementEnded(_ gamepad: Gamepad, _ dPad: DirectionalPad)
}

extension UIResponder: EventResponder {
    
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
