//
//  GamepadDelegate.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/14/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

/// A `GamepadDelegate` is responsible for setting up the pause button handler.
@objc public protocol GamepadDelegate: AnyObject {
    
    /// The signature of a PauseHandler function.
    typealias PauseHandler = ( _ gamepad: Gamepad) -> Void
    
    /// The function that the delegate should implement in order to have it called by the `Gamepad` whent he pause button is pressed.
    @objc optional func pauseHandler(gamepad: Gamepad)
}
