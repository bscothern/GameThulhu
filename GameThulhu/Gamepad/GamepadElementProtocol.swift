//
//  GamepadElementProtocol.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/8/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

public protocol GamepadElementProtocol {
    func gcElement(gamepad: GCExtendedGamepad) ->  GCControllerElement
}
