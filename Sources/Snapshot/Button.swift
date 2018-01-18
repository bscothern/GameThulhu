//
//  Button.swift
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

/// This struct represents the state of a button on a game controller device
@objc public class Button: NSObject {

    /// The button elements type so you can identify which button this is on the `Gamepad`.
    public let type: ButtonType

    /// Ranging from `0.0` to `1.0` depending on the pressure on the button.
    public let value: Float

    /// If the system considers the button pressed.
    public let isPressed: Bool

    /// The main constructor for a Button. A Button represents the state of the Button on a game controller.
    ///
    /// - Parameters:
    ///   - type: The type of button this is.
    ///   - value: Ranging from `0.0` to `1.0` depending on the pressure on the button. This value is clamped.
    ///   - isPressed: If the system considers the button pressed.
    public init(type: ButtonType, value: Float, isPressed: Bool) {
        self.type = type
        self.value = value.clamped(to: 0.0...1.0)
        self.isPressed = isPressed
    }

    /// A convenient constructor for a Button. It uses the default Apple representation and converts it.
    ///
    /// - Parameters
    ///   - type: The type of button this is.
    ///   - button: The `GCControllerButtonInput` that should be converted.
    public convenience init(type: ButtonType, button: GCControllerButtonInput) {
        self.init(type: type, value: button.value, isPressed: button.isPressed)
    }

    //MARK:- Protocol Conformance
    //MARK: Equatable
    public static func == (lhs: Button, rhs: Button) -> Bool {
        return lhs.type == rhs.type &&
            lhs.value == rhs.value &&
            lhs.isPressed == rhs.isPressed
    }

    //MARK: Hashable
    override public var hashValue: Int {
        return (Int(value.bitPattern) * (isPressed ? 1:-1)) ^ (type.hashValue << 48)
    }
}

extension Button {
    override public var debugDescription: String {
        return "Button - isPressed: \(isPressed)\tvalue: \(value.format("%0.2"))"
    }
}
