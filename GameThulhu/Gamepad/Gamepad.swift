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
    //MARK: Private
    private var connectedObserver: GameControllerDiscovery.Observer! = nil
    private var disconnectedObserver: GameControllerDiscovery.Observer! = nil
    
    //MARK: Public
    
    /// The `GCController` that backs up the `Gamepad`.
    public let controller: GCController
    
    /// If `true` then the `controller` is still connected to the device and is valid to work with, if `false` it has been disconnected and will not work.
    public private(set) var isConnected: Bool = true

    ///MARK:- Init
    public init?(controller: GCController) {
        self.controller = controller
        
        super.init()
        
        connectedObserver = GameControllerDiscovery.observeControllerConnected { [weak self](controller: GCController) in
            if controller == self?.controller {
                self?.isConnected = true
            }
        }
        
        disconnectedObserver = GameControllerDiscovery.observeControllerDisconnected { [weak self](controller: GCController) in
            if controller == self?.controller {
                self?.isConnected = false
            }
        }
    }
    
    deinit {
        GameControllerDiscovery.unobserveControllerConnected(observer: connectedObserver)
        GameControllerDiscovery.unobserveControllerDisconnected(observer: disconnectedObserver)
    }
}
