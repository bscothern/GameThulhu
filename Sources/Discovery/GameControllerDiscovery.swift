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
#if !os(tvOS)
    import NotificationCenter
#endif

/// This class is used to simplify the process of knowing when a controller has connected or disconnected.
@objc public class GameControllerDiscovery: NSObject {

    //MARK:- Types
    //MARK: Public

    /// A function that should be called on a controller connection/disconnection events.
    ///
    /// - Parameter controller: The controller which has just had its connection status change.
    public typealias ConnectionEventCallback = (_ controller: GCController) -> Void

    /// An object used to identify GameControllerDiscovery events for connection or disconnection events of `GCController` instances.
    ///
    /// These must be used to unobserver the event they are created for or else a memory leak will occur.
    public typealias Observer = AnyObject

    //MARK: Internal

    /// The type used to keep track of callbacks.
    internal class CallbackObserver: Hashable {

        /// When set to `false` it is assumed to be an `GameThulhu` callback function meaning it should execute before any public callbacks.
        internal var isPublic: Bool = true

        internal var hashValue: Int {
            return Int(bitPattern: Unmanaged<CallbackObserver>.passUnretained(self).toOpaque())
        }

        internal static func == (lhs: GameControllerDiscovery.CallbackObserver, rhs: GameControllerDiscovery.CallbackObserver) -> Bool {
            return lhs === rhs
        }
    }

    //MARK:- Properties
    //MARK: Public Static

    /// An array of controllers currently connected to the system
    public static var controllers: [GCController] {
        return GCController.controllers()
    }

    //MARK: Private Static

    /// The lock that protects `GameControllerDiscovery.connectedCallbacks`.
    private static let connectedCallbacksLock = NSRecursiveLock()

    /// The map of observer to callbacks that should be executed on a GCController connect event.
    private static var connectedCallbacks: [CallbackObserver: ConnectionEventCallback] = [:] {
        didSet {
            if GameControllerDiscovery.connectedCallbacks.count == 0 {
                GameControllerDiscovery.connectedObserverLock.execute {
                    GameControllerDiscovery.connectedObserver = nil
                }
            } else {
                GameControllerDiscovery.setConnectObseverFunc()
            }
        }
    }

    /// The lock that protects `GameControllerDiscovery.connectedObserver`.
    private static let connectedObserverLock = NSRecursiveLock()

    /// The NotificationCenter callback observer that identifies the connect event callback for `GCController`'s.
    private static var connectedObserver: NSObjectProtocol? {
        willSet {
            guard let connectedObserver = GameControllerDiscovery.connectedObserver else {
                return
            }
            NotificationCenter.default.removeObserver(connectedObserver)
        }
    }

    // The lock that protects `GameControllerDiscovery.disconnectedCallbacks`.
    private static let disconnectedCallbacksLock = NSRecursiveLock()

    /// The map of observer to callbacks that should be executed on a GCController disconnect event.
    private static var disconnectedCallbacks: [CallbackObserver: ConnectionEventCallback] = [:] {
        didSet {
            if GameControllerDiscovery.disconnectedCallbacks.count == 0 {
                GameControllerDiscovery.disconnectedObserverLock.execute {
                    GameControllerDiscovery.disconnectedObserver = nil
                }
            } else {
                GameControllerDiscovery.setDisconnectObserverFunc()
            }
        }
    }

    // The lock that protects `GameControllerDiscovery.disconnectedObserver`.
    private static let disconnectedObserverLock = NSRecursiveLock()

    /// The NotificationCenter callback observer that identifies the disconnect event callback for `GCController`'s.
    private static var disconnectedObserver: NSObjectProtocol? {
        willSet {
            guard let disconnectedObserver = GameControllerDiscovery.disconnectedObserver else {
                return
            }
            NotificationCenter.default.removeObserver(disconnectedObserver)
        }
    }

    //MARK:- Funcs
    //MARK: Public Static

    /// Used to set up a callback when a controller has been connected.
    ///
    /// - Parameter callback: The function that should be called when a new controller is found by the system.
    /// - Returns: An `Observer` which can be used to unobserve controller connection events via `unobserveControllerConnected()`.
    public static func observeControllerConnected(callback: @escaping ConnectionEventCallback) -> Observer {
        let observer = CallbackObserver()
        GameControllerDiscovery.connectedCallbacksLock.execute {
            GameControllerDiscovery.connectedCallbacks[observer] = callback
        }
        return observer
    }

    /// Used to stop receving callbacks when a controller has been connected.
    ///
    /// - Parameter observer: An `Observer` received from a call to `observeControllerConnected()` that is used to unobserve connection events.
    public static func unobserveControllerConnected(observer: Observer) {
        guard let observer = observer as? CallbackObserver else {
            return
        }
        GameControllerDiscovery.connectedCallbacksLock.execute {
            _ = GameControllerDiscovery.connectedCallbacks.removeValue(forKey: observer)
        }
    }

    /// Used to set up a callback when a controller has been disconnected.
    ///
    /// - Parameter callback: The function that should be called when a controller is disconnected from the system.
    /// - Returns: An `Observer` which can be used to unobserve controller disconnect events via `unobserveControllerDisconnected()`.
    public static func observeControllerDisconnected(callback: @escaping ConnectionEventCallback) -> Observer {
        let observer = CallbackObserver()
        GameControllerDiscovery.disconnectedCallbacksLock.execute {
            GameControllerDiscovery.disconnectedCallbacks[observer] = callback
        }
        return observer
    }

    /// Used to stop receving callbacks when a controller has been disconnected.
    ///
    /// - Parameter observer: An `Observer` received from a call to `observeControllerDisconnected()` that is used to unobserve disconnection events.
    public static func unobserveControllerDisconnected(observer: Observer) {
        guard let observer = observer as? CallbackObserver else {
            return
        }
        GameControllerDiscovery.disconnectedCallbacksLock.execute {
            _ = GameControllerDiscovery.disconnectedCallbacks.removeValue(forKey: observer)
        }
    }

    //MARK: Private Static

    /// Ensure that NotificationCenter is watching for GCController connect events and going to call our callbacks.
    private static func setConnectObseverFunc() {
        GameControllerDiscovery.connectedObserverLock.execute {
            guard GameControllerDiscovery.connectedObserver == nil else {
                return
            }
            GameControllerDiscovery.connectedObserver = NotificationCenter.default.addObserver(forName: Notification.Name.GCControllerDidConnect, object: nil, queue: nil) { (notification: Notification) in
                guard let controller = notification.object as? GCController else {
                    return
                }
                GameControllerDiscovery.connectedCallbacksLock.execute {
                    // Call internal callbacks before public ones
                    for callback in GameControllerDiscovery.connectedCallbacks.filter({ !$0.key.isPublic }).values {
                        callback(controller)
                    }
                    for callback in GameControllerDiscovery.connectedCallbacks.filter({ $0.key.isPublic }).values {
                        callback(controller)
                    }
                }
            }
        }
    }

    /// Ensure that NotificationCenter is watching for GCController disconnect events and going to call our callbacks.
    private static func setDisconnectObserverFunc() {
        GameControllerDiscovery.disconnectedObserverLock.execute {
            guard GameControllerDiscovery.disconnectedObserver == nil else {
                return
            }
            GameControllerDiscovery.disconnectedObserver = NotificationCenter.default.addObserver(forName: Notification.Name.GCControllerDidDisconnect, object: nil, queue: nil) { (notification: Notification) in
                guard let controller = notification.object as? GCController else {
                    return
                }
                GameControllerDiscovery.disconnectedCallbacksLock.execute {
                    // Call internal callbacks before public ones
                    for callback in GameControllerDiscovery.disconnectedCallbacks.filter({ !$0.key.isPublic }).values {
                        callback(controller)
                    }
                    for callback in GameControllerDiscovery.disconnectedCallbacks.filter({ $0.key.isPublic }).values {
                        callback(controller)
                    }
                }
            }
        }
    }

}
