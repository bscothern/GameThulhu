//
//  Controller.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// A wrapper class around `GCController` and its gamepad. This class shouldn't be used directly, instead you should use `ExtendedController`, `MicroController`, or `TBD`.
public class Gamepad {
    internal let controller: GCController
    
    internal init?(controller: GCController) {
        self.controller = controller
    }
}
