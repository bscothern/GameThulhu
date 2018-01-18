//
//  GameControllerDiscovery.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import GameController
import NotificationCenter

/// This class is used to simplify the process of knowing when a controller has connected or disconnected.
@objc public class GameControllerDiscovery: NSObject {

    /// A function that should be called on a controller connection/disconnection events.
    ///
    /// - Parameter controller: The controller which has just had its connection status change.
    public typealias ConnectionEventCallback = (_ controller: GCController) -> Void

    /// An object returned from NotificationCenter that should be used to unsubscribe from controller connection/disconnection event callbacks.
    public typealias Observer = NSObjectProtocol

    /// An array of controllers currently connected to the system
    public static var controllers: [GCController] {
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
