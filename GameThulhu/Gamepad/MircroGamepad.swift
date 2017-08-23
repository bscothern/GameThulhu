//
//  MircroGamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// **NOT YET SUPPORTED**
public class MicroGamepad: Gamepad {

    /// Creates an `MicroController` if the given `GCController` is an `GCMicroGamepad`.
    ///
    /// - parameter controller: The `GCController` which this `ExtendedController` should use. If the property `extendedGampead` returns `nil` this constructor will fail.
    public override init?(controller: GCController) {
        guard controller.microGamepad != nil else {
            return nil
        }
        super.init(controller: controller)
    }
}
