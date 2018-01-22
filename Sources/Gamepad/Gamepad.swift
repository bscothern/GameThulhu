//
//  Gamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
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

import Foundation
import GameController

/// A wrapper class around `GCController` and its gamepad. Typically you should use `ExtendedController` or `MicroController`. This just provides consistency and a super type to both Controller types.
@objc public class Gamepad: NSObject {
    ///MARK:- Properties
    //MARK: Private
    private var connectedObserver: GameControllerDiscovery.Observer! = nil {
        didSet {
            (connectedObserver as? GameControllerDiscovery.CallbackObserver)?.isPublic = false
        }
    }
    private var disconnectedObserver: GameControllerDiscovery.Observer! = nil {
        didSet {
            (disconnectedObserver as? GameControllerDiscovery.CallbackObserver)?.isPublic = false
        }
    }

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
