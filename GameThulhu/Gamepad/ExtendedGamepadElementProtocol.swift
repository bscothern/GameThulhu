//
//  ExtendedGamepadElementProtocol.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/8/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

public protocol ExtendedGamepadElementProtocol: GamepadElementProtocol {
    var element: ExtendedGamepad.Element { get }
}
