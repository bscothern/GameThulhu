//
//  GamepadDelegate.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/14/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

@objc public protocol GamepadDelegate: AnyObject {
    @objc optional func pauseHandler(gamepad: Gamepad)
}
