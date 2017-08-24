//
//  ExtendedSnapshot.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

// This struct represents all of the data found at a moment of time from a game controller.
public struct ExtendedSnapshot {
    /// A `Button` representing the the **A** button on a controller.
    public let buttonA: Button
    
    /// A `Button` representing the the **B** button on a controller.
    public let buttonB: Button
    
    /// A `Button` representing the the **X** button on a controller.
    public let buttonX: Button
    
    /// A `Button` representing the the **Y** button on a controller.
    public let buttonY: Button
    
    /// A `Button` representing the the **L1** bumper on a controller.
    public let L1: Button
    
    /// A `Button` representing the the **L2** trigger on a controller.
    public let L2: Button
    
    /// A `Button` representing the the **R1** bumper on a controller.
    public let R1: Button
    
    /// A `Button` representing the the **R2** trigger on a controller.
    public let R2: Button
    
    /// A `DirectionalPad` representing the **D-Pad** on a controller.
    public let dPad: DirectionalPad
    
    /// A `DirectionalPad` representing the **Left Joystick** on a controller.
    public let leftJoystick: DirectionalPad
    
    /// A `DirectionalPad` representing the **Right Joystick** on a controller.
    public let rightJoystick: DirectionalPad
    
    
    /// The constructor for an ExtendedSnapshot.
    ///
    /// - Parameter snapshot: The raw game controller snapshot that should be used to create the ExtendedSnapshot.
    public init(_ snapshot: GCExtendedGamepadSnapshot) {
        buttonA = Button(type: .buttonA, button: snapshot.buttonA)
        buttonB = Button(type: .buttonB, button: snapshot.buttonB)
        buttonX = Button(type: .buttonX, button: snapshot.buttonX)
        buttonY = Button(type: .buttonY, button: snapshot.buttonY)
        
        L1 = Button(type: .L1, button: snapshot.leftShoulder)
        L2 = Button(type: .L2, button: snapshot.leftTrigger)
        
        R1 = Button(type: .R1, button: snapshot.rightShoulder)
        R2 = Button(type: .R2, button: snapshot.rightTrigger)
        
        dPad = DirectionalPad(type: .dPad, dPad: snapshot.dpad)
        leftJoystick = DirectionalPad(type: .leftJoystick, dPad: snapshot.leftThumbstick)
        rightJoystick = DirectionalPad(type: .rightJoystick, dPad: snapshot.rightThumbstick)
    }
}

extension ExtendedSnapshot: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Snapshot:\nA: (\(buttonA.debugDescription))\t\tB: (\(buttonB.debugDescription))\nX: (\(buttonX.debugDescription)\t\tY: (\(buttonY.debugDescription)\nL1: (\(L1.debugDescription)\t\tL2: (\(L2.debugDescription)\nR1: (\(R1.debugDescription)\t\tR2: (\(R2.debugDescription)\nDPad: (\(dPad.debugDescription)\nLeft Joystick: (\(leftJoystick.debugDescription))\nRight Joystick: (\(rightJoystick.debugDescription)"
    }
}



