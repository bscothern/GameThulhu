//
//  ExtenededGamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// A wrapper for `GCController` that can only be constructed if the given `GCController` is a `GCExtendedGamepad`. It provides lots of convenient functionality for interactions with the gamepad.
public class ExtendedGamepad: Gamepad {
    
    /**
     Creates an `ExtendedController` if the given `GCController` is an `GCExtendedGamepad`.
     
     - parameters:
        - controller: The `GCController` which this `ExtendedController` should use. If the property `extendedGampead` returns `nil` this constructor will fail.
     */
    public override init?(controller: GCController) {
        guard controller.extendedGamepad != nil else {
            return nil
        }
        super.init(controller: controller)
    }
}
