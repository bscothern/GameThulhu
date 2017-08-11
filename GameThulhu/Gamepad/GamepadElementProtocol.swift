//
//  GamepadElementProtocol.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/8/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// The protocol that all `Gamepad` elements conform to.
public protocol GamepadElementProtocol {
    
    /// Return the `GCControllerElement` of the `gamepad` that cooresponds to this `GamepadElementProtocol`
    ///
    /// - Parameter gamepad: The `GCExtendedGamepad` which has the `GCControllerElement` that is desired.
    /// - Returns: The `GCControllerElement` that cooresponds to the `ExtendedGamepad.ButtonElement`.
    func gcElement(gamepad: GCExtendedGamepad) ->  GCControllerElement
}
