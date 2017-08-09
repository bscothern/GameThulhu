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
    
    /// Ranging from 0 to 1 depending on the pressure on the button.
    public var value: Float
    
    /// If the system considers the button pressed.
    public var isPressed: Bool
    
    /**
     The main constructor for a Button. A Button represents the state of the Button on a game controller.
     - parameters:
         - value: Ranging from 0 to 1 depending on the pressure on the button.
         - pressed: If the system considers the button pressed.
     */
    public init(value: Float, isPressed: Bool) {
        self.value = value //min(max(, 0.0), 1.0)
        self.isPressed = isPressed
    }
    
    /**
     A convenient constructor for a Button. It uses the default Apple representation and converts it.
     - parameters:
         - button: The button that should be converted.
     */
    public init(_ button: GCControllerButtonInput) {
        self.init(value: button.value, isPressed: button.isPressed)
    }
}

extension Button: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Button - isPressed: \(isPressed)\tvalue: \(value.format("%0.2"))"
    }
}
