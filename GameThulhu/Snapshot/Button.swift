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
public struct Button {
    
    /// Ranging from `0.0` to `1.0` depending on the pressure on the button.
    public let value: Float
    
    /// If the system considers the button pressed.
    public let isPressed: Bool
    
    /// The main constructor for a Button. A Button represents the state of the Button on a game controller.
    ///
    /// - Parameters:
    ///   - value: Ranging from `0.0` to `1.0` depending on the pressure on the button. This value is clamped.
    ///   - isPressed: If the system considers the button pressed.
    public init(value: Float, isPressed: Bool) {
        self.value = value.clamped(to: 0.0...1.0)
        self.isPressed = isPressed
    }
    
    /// A convenient constructor for a Button. It uses the default Apple representation and converts it.
    ///
    /// - Parameter button: The button that should be converted.
    public init(_ button: GCControllerButtonInput) {
        self.init(value: button.value, isPressed: button.isPressed)
    }
}

extension Button: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Button - isPressed: \(isPressed)\tvalue: \(value.format("%0.2"))"
    }
}
