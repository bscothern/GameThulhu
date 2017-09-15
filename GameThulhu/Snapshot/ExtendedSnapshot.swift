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
@objc public class ExtendedSnapshot: NSObject {
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
    
    //MARK:- Protocol Conformance
    //MARK: Equtable
    public static func == (lhs: ExtendedSnapshot, rhs: ExtendedSnapshot) -> Bool {
        return lhs.buttonA == rhs.buttonA &&
            lhs.buttonB == rhs.buttonB &&
            lhs.buttonX == rhs.buttonX &&
            lhs.buttonY == rhs.buttonY &&
            lhs.L1 == rhs.L1 &&
            lhs.L2 == rhs.L2 &&
            lhs.R1 == rhs.R1 &&
            lhs.R2 == rhs.R2 &&
            lhs.dPad == rhs.dPad &&
            lhs.leftJoystick == rhs.leftJoystick &&
            lhs.rightJoystick == rhs.rightJoystick
    }
    
    //MARK: Hashable
    override public var hashValue: Int {
        let hash1 = buttonA.hashValue ^ (buttonB.hashValue << 8) ^ (buttonX.hashValue << 16) ^ (buttonY.hashValue << 32)
        let hash2 = (L1.hashValue << 3) ^ (L2.hashValue << 9) ^ (R1.hashValue << 27) ^ (R2.hashValue << 17) // (3^1 % 64), (3^2 % 64), (3^3 % 64), (3^4 % 64)
        let hash3 = dPad.hashValue ^ (leftJoystick.hashValue << 40) ^ (rightJoystick.hashValue << 48)
        return hash1 ^ hash2 ^ hash3
    }
}

extension ExtendedSnapshot {
    override public var debugDescription: String {
        return "Snapshot:\nA: (\(buttonA.debugDescription))\t\tB: (\(buttonB.debugDescription))\nX: (\(buttonX.debugDescription)\t\tY: (\(buttonY.debugDescription)\nL1: (\(L1.debugDescription)\t\tL2: (\(L2.debugDescription)\nR1: (\(R1.debugDescription)\t\tR2: (\(R2.debugDescription)\nDPad: (\(dPad.debugDescription)\nLeft Joystick: (\(leftJoystick.debugDescription))\nRight Joystick: (\(rightJoystick.debugDescription)"
    }
}



