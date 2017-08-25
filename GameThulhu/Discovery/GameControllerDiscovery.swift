//
//  GameControllerDiscovery.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import GameController
import NotificationCenter

/// This class is used to simplify the process of knowing when a controller has connected or disconnected.
public class GameControllerDiscovery {
    
    /// A function that should be called on a controller connection/disconnection events.
    ///
    /// - Parameter controller: The controller which has just had its connection status change.
    public typealias ConnectionEventCallback = (_ controller: GCController) -> Void
    
    /// An object returned from NotificationCenter that should be used to unsubscribe from controller connection/disconnection event callbacks.
    public typealias Observer = NSObjectProtocol
    
    /// An array of controllers currently connected to the system
    public var controllers: [GCController] {
        return GCController.controllers()
    }
    
    /// Used to set up a callback when a controller has been connected.
    ///
    /// - Parameter callback: The function that should be called when a new controller is found by the system.
    /// - Returns: An `Observer` which can be used to unobserve controller connection events via `unobserveControllerConnected()`.
    public static func observeControllerConnected(callback: @escaping ConnectionEventCallback) -> Observer {
        return NotificationCenter.default.addObserver(forName: Notification.Name.GCControllerDidConnect, object: nil, queue: nil) { (notifcation: Notification) -> Void in
            guard let controller = notifcation.object as? GCController else {
                return
            }
            callback(controller)
        }
    }
    
    /// Used to stop receving callbacks when a controller has been connected.
    ///
    /// - Parameter observer: An `Observer` received from a call to `observeControllerConnected()` that is used to unobserve connection events.
    public static func unobserveControllerConnected(observer: Observer) {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name.GCControllerDidConnect, object: nil)
    }
    
    /// Used to set up a callback when a controller has been disconnected.
    ///
    /// - Parameter callback: The function that should be called when a controller is disconnected from the system.
    /// - Returns: An `Observer` which can be used to unobserve controller disconnect events via `unobserveControllerDisconnected()`.
    public static func observeControllerDisconnected(callback: @escaping ConnectionEventCallback) -> Observer {
        return NotificationCenter.default.addObserver(forName: Notification.Name.GCControllerDidDisconnect, object: nil, queue: nil) { (notifcation: Notification) -> Void in
            guard let controller = notifcation.object as? GCController else {
                return
            }
            callback(controller)
        }
    }
    
    /// Used to stop receving callbacks when a controller has been disconnected.
    ///
    /// - Parameter observer: An `Observer` received from a call to `observeControllerDisconnected()` that is used to unobserve disconnection events.
    public static func unobserveControllerDisconnected(observer: Observer) {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name.GCControllerDidDisconnect, object: nil)
    }
}
