//
//  Button.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// This struct represents the state of a button on a game controller device
public struct Button: Hashable {
    
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
    public init(type: ButtonType, button: GCControllerButtonInput) {
        self.init(type: type, value: button.value, isPressed: button.isPressed)
    }
    
    //MARK:- Protocol Conformance
    //MARK: Equatable
    public static func ==(lhs: Button, rhs: Button) -> Bool {
        return lhs.value == rhs.value &&
            lhs.isPressed == rhs.isPressed
    }
    
    //MARK: Hashable
    public var hashValue: Int {
        return Int(value.bitPattern) * (isPressed ? 1:-1)
    }
}

extension Button: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Button - isPressed: \(isPressed)\tvalue: \(value.format("%0.2"))"
    }
}
