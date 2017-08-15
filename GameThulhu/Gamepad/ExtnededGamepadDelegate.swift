//
//  ExtnededGamepadDelegate.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/14/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

@objc public protocol ExtendedGamepadDelegate: GamepadDelegate {
    @objc optional func buttonAChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func buttonAPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func buttonBChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func buttonBPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func buttonXChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func buttonXPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func buttonYChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func buttonYPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func L1Changed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func L1Pressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func L2Changed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func L2Pressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func R1Changed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func R1Pressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func R2Changed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func R2Pressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func dPadChanged(gamepad: ExtendedGamepad, xValue: Float, yValue: Float)
    
    @objc optional func dPadUpChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func dPadUpPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func dPadDownChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func dPadDownPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func dPadLeftChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func dPadLeftPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func dPadRightChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func dPadRightPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func leftJoystickChanged(gamepad: ExtendedGamepad, xValue: Float, yValue: Float)
    
    @objc optional func leftJoystickUpChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func leftJoystickUpPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func leftJoystickDownChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func leftJoystickDownPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func leftJoystickLeftChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func leftJoystickLeftPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func leftJoystickRightChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func leftJoystickRightPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)

    @objc optional func rightJoystickChanged(gamepad: ExtendedGamepad, xValue: Float, yValue: Float)
    
    @objc optional func rightJoystickUpChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func rightJoystickUpPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func rightJoystickDownChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func rightJoystickDownPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func rightJoystickLeftChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func rightJoystickLeftPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    
    @objc optional func rightJoystickRightChanged(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
    @objc optional func rightJoystickRightPressed(gamepad: ExtendedGamepad, value: Float, pressed: Bool)
}
