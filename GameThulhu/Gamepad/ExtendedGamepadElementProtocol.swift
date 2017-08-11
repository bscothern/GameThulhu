//
//  ExtendedGamepadElementProtocol.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/8/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

/// THe protocol that all `ExtendedGamepad` element types conform to.
public protocol ExtendedGamepadElementProtocol: GamepadElementProtocol {
    /// The `ExtendedGamepad.Element` representation of this `ExtendedGamepadElementProtocol`.
    var element: ExtendedGamepad.Element { get }
}
