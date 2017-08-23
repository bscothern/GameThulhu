//
//  Gamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController


/// A wrapper class around `GCController` and its gamepad. Typically you should use `ExtendedController`, `MicroController`, or `TBD`
@objc public class Gamepad: NSObject {
    ///MARK:- Properties
    ///MARK: Internal
    internal let controller: GCController
    
    ///MARK: Public
    public weak var gamePadDelegate: GamepadDelegate? = nil {
        didSet {
            controller.controllerPausedHandler = (gamePadDelegate?.pauseHandler == nil) ? nil:{ [weak self](controller: GCController) -> Void in
                guard let _self = self else {
                    controller.controllerPausedHandler = nil
                    return
                }
                _self.gamePadDelegate?.pauseHandler?(gamepad: _self)
            }
        }
    }

    ///MARK:- Init
    public init?(controller: GCController) {
        self.controller = controller
    }
}
