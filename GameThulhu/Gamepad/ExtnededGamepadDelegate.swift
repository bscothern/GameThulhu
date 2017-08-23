//
//  ExtnededGamepadDelegate.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/14/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol ExtendedGamepadDelegate1: GamepadDelegate {
    
    typealias ButtonCallback = (_ gamepad: ExtendedGamepad, _ value: Float, _ pressed: Bool, _ properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue]) -> Void
    typealias DirectionalPadCallback = (_ gamepad: ExtendedGamepad, _ xValue: Float, _ yValue: Float) -> Void
    
    @objc optional func buttonA(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func buttonB(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func buttonX(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func buttonY(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    
    @objc optional func L1(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func L2(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func R1(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func R2(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    
    @objc optional func dPad(gamepad: ExtendedGamepad, xValue: Float, yValue: Float)
    
    @objc optional func dPadUp(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func dPadDown(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func dPadLeft(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func dPadRight(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    
    @objc optional func leftJoystick(gamepad: ExtendedGamepad, xValue: Float, yValue: Float)
    
    @objc optional func leftJoystickUp(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func leftJoystickDown(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func leftJoystickLeft(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func leftJoystickRight(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])

    @objc optional func rightJoystick(gamepad: ExtendedGamepad, xValue: Float, yValue: Float)
    
    @objc optional func rightJoystickUp(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func rightJoystickDown(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func rightJoystickLeft(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
    @objc optional func rightJoystickRight(gamepad: ExtendedGamepad, value: Float, pressed: Bool, properties: [ExtendedGamepad.ButtonProperty: ExtendedGamepad.ButtonPropertyValue])
}
