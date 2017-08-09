//
//  Gamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/**
 A wrapper class around `GCController` and its gamepad. Typically you should use `ExtendedController`, `MicroController`, or `TBD`
 */
public class Gamepad {
    public typealias PauseHandler = (Gamepad) -> Void

    internal let controller: GCController
    
    private var _pauseHandler: PauseHandler? = nil
    var pauseHandler: PauseHandler? {
        get { return _pauseHandler }
        set {
            controller.controllerPausedHandler = { [weak self](controller: GCController) -> Void in
                guard let _self = self else { return }
                _self._pauseHandler?(_self)
            }
        }
    }
    
    internal init?(controller: GCController) {
        self.controller = controller
    }
}
