//
//  Gamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController


/// A wrapper class around `GCController` and its gamepad. Typically you should use `ExtendedController` or `MicroController`. This just provides consistency and a super type to both Controller types.
@objc public class Gamepad: NSObject {
    ///MARK:- Properties
    ///MARK: Internal
    internal let controller: GCController

    ///MARK:- Init
    public init?(controller: GCController) {
        self.controller = controller
    }
}
