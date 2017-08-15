//
//  ExtendededGamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// A wrapper for `GCController` that can only be constructed if the given `GCController` is a `GCExtendedGamepad`. It provides lots of convenient functionality for interactions with the gamepad.
@objc public class ExtendedGamepad: Gamepad {
    //MARK:- Properties
    //MARK: Private
    
    /// Used to access the GCExtendedGamepad for this object.
    fileprivate var extendedGamepad: GCExtendedGamepad {
        return controller.extendedGamepad!
    }
    
    //MARK: Public
    
    /// The current view of the ExtendedGamepad's values.
    public var snapshot: ExtendedSnapshot {
        return ExtendedSnapshot(rawSnapshot)
    }
    
    /// The default snapshot object. It is usually wrapped into an `ExtendedSnapshot` to remove the clutter since they are immutable.
    public var rawSnapshot: GCExtendedGamepadSnapshot {
        return extendedGamepad.saveSnapshot()
    }
    
    public weak var extendedGamepadDelegate: ExtendedGamepadDelegate? = nil {
        didSet {
            gamePadDelegate = extendedGamepadDelegate
            configureExtendedGamepadDelegate()
        }
    }
    
    //MARK:- Init
    
    /// Creates an `ExtendedController` if the given `GCController` is an `GCExtendedGamepad`.
    ///
    /// - Parameter controller: The `GCController` which this `ExtendedController` should use. If the property `extendedGampead` returns `nil` this constructor will fail.
    public override init?(controller: GCController) {
        guard controller.extendedGamepad != nil else {
            return nil
        }
        super.init(controller: controller)
    }

    //MARK:- Funcs
    //MARK: Private
    
    /// Used to assign `nil` to all callbacks on a button.
    ///
    /// - Parameter button: The `GCControllerButtonInput` which should have its callbacks set to `nil`.
    @inline(__always) private func nilify(button: GCControllerButtonInput) {
        button.pressedChangedHandler = nil
        button.valueChangedHandler = nil
    }
    
    /// Used to assign `nil` to all callbacks on a directional pad, including its button elements.
    ///
    /// - Parameter dPad: The `GCControllerDirectionPad` which should have its callbacks set to `nil`.
    @inline(__always) private func nilify(dPad: GCControllerDirectionPad) {
        nilify(button: dPad.up)
        nilify(button: dPad.down)
        nilify(button: dPad.left)
        nilify(button: dPad.right)
        
        dPad.valueChangedHandler = nil
    }
    
    @inline(__always) private func configureHandlers(button: GCControllerButtonInput, changedCallback: ((ExtendedGamepad, Float, Bool) -> Void)?, pressedCallback: ((ExtendedGamepad, Float, Bool) -> Void)?) {
        button.valueChangedHandler = (changedCallback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
            guard let _self = self else {
                button.valueChangedHandler = nil
                return
            }
            changedCallback?(_self, value, pressed)
        }
        
        button.pressedChangedHandler = (pressedCallback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
            guard let _self = self else {
                button.pressedChangedHandler = nil
                return
            }
            pressedCallback?(_self, value, pressed)
        }
    }
    
    @inline(__always) private func configureHandlers(dpad: GCControllerDirectionPad, callback: ((ExtendedGamepad, Float, Float) -> Void)?) {
        dpad.valueChangedHandler = (callback == nil) ? nil:{ [weak self](dpad: GCControllerDirectionPad, xValue: Float, yValue: Float) -> Void in
            guard let _self = self else {
                dpad.valueChangedHandler = nil
                return
            }
            callback?(_self, xValue, yValue)
        }
    }
    
    private func configureExtendedGamepadDelegate() {
        //MARK: Verify extendedGamepadDelegate
        guard extendedGamepadDelegate != nil else {
            nilify(button: extendedGamepad.buttonA)
            nilify(button: extendedGamepad.buttonB)
            nilify(button: extendedGamepad.buttonX)
            nilify(button: extendedGamepad.buttonY)
            
            nilify(button: extendedGamepad.leftShoulder)
            nilify(button: extendedGamepad.leftTrigger)
            nilify(button: extendedGamepad.rightShoulder)
            nilify(button: extendedGamepad.rightTrigger)
            
            nilify(dPad: extendedGamepad.dpad)
            nilify(dPad: extendedGamepad.leftThumbstick)
            nilify(dPad: extendedGamepad.rightThumbstick)
            
            return
        }
        
        //MARK: Configure Button Callbacks
        configureHandlers(button: extendedGamepad.buttonA, changedCallback: extendedGamepadDelegate?.buttonAChanged, pressedCallback: extendedGamepadDelegate?.buttonAPressed)
        configureHandlers(button: extendedGamepad.buttonB, changedCallback: extendedGamepadDelegate?.buttonBChanged, pressedCallback: extendedGamepadDelegate?.buttonBPressed)
        configureHandlers(button: extendedGamepad.buttonX, changedCallback: extendedGamepadDelegate?.buttonXChanged, pressedCallback: extendedGamepadDelegate?.buttonXPressed)
        configureHandlers(button: extendedGamepad.buttonY, changedCallback: extendedGamepadDelegate?.buttonYChanged, pressedCallback: extendedGamepadDelegate?.buttonYPressed)
        
        //MARK: Configure Trigger Button Callbacks
        configureHandlers(button: extendedGamepad.leftShoulder, changedCallback: extendedGamepadDelegate?.L1Changed, pressedCallback: extendedGamepadDelegate?.L1Pressed)
        configureHandlers(button: extendedGamepad.leftTrigger, changedCallback: extendedGamepadDelegate?.L2Changed, pressedCallback: extendedGamepadDelegate?.L2Pressed)
        configureHandlers(button: extendedGamepad.rightShoulder, changedCallback: extendedGamepadDelegate?.R1Changed, pressedCallback: extendedGamepadDelegate?.R1Pressed)
        configureHandlers(button: extendedGamepad.rightTrigger, changedCallback: extendedGamepadDelegate?.R2Changed, pressedCallback: extendedGamepadDelegate?.R2Pressed)
        
        //MARK: Configure DPad
        configureHandlers(dpad: extendedGamepad.dpad, callback: extendedGamepadDelegate?.dPadChanged)
        configureHandlers(button: extendedGamepad.dpad.up, changedCallback: extendedGamepadDelegate?.dPadUpChanged, pressedCallback: extendedGamepadDelegate?.dPadUpPressed)
        configureHandlers(button: extendedGamepad.dpad.down, changedCallback: extendedGamepadDelegate?.dPadDownChanged, pressedCallback: extendedGamepadDelegate?.dPadDownPressed)
        configureHandlers(button: extendedGamepad.dpad.left, changedCallback: extendedGamepadDelegate?.dPadLeftChanged, pressedCallback: extendedGamepadDelegate?.dPadLeftPressed)
        configureHandlers(button: extendedGamepad.dpad.right, changedCallback: extendedGamepadDelegate?.dPadRightChanged, pressedCallback: extendedGamepadDelegate?.dPadRightPressed)

        //MARK: Configure Left Joystick
        configureHandlers(dpad: extendedGamepad.leftThumbstick, callback: extendedGamepadDelegate?.leftJoystickChanged)
        configureHandlers(button: extendedGamepad.leftThumbstick.up, changedCallback: extendedGamepadDelegate?.leftJoystickUpChanged, pressedCallback: extendedGamepadDelegate?.leftJoystickUpPressed)
        configureHandlers(button: extendedGamepad.leftThumbstick.down, changedCallback: extendedGamepadDelegate?.leftJoystickDownChanged, pressedCallback: extendedGamepadDelegate?.leftJoystickDownPressed)
        configureHandlers(button: extendedGamepad.leftThumbstick.left, changedCallback: extendedGamepadDelegate?.leftJoystickLeftChanged, pressedCallback: extendedGamepadDelegate?.leftJoystickLeftPressed)
        configureHandlers(button: extendedGamepad.leftThumbstick.right, changedCallback: extendedGamepadDelegate?.leftJoystickRightChanged, pressedCallback: extendedGamepadDelegate?.leftJoystickRightPressed)
        
        //MARK: Configure Right Joystick
        configureHandlers(dpad: extendedGamepad.rightThumbstick, callback: extendedGamepadDelegate?.rightJoystickChanged)
        configureHandlers(button: extendedGamepad.rightThumbstick.up, changedCallback: extendedGamepadDelegate?.rightJoystickUpChanged, pressedCallback: extendedGamepadDelegate?.rightJoystickUpPressed)
        configureHandlers(button: extendedGamepad.rightThumbstick.down, changedCallback: extendedGamepadDelegate?.rightJoystickDownChanged, pressedCallback: extendedGamepadDelegate?.rightJoystickDownPressed)
        configureHandlers(button: extendedGamepad.rightThumbstick.left, changedCallback: extendedGamepadDelegate?.rightJoystickLeftChanged, pressedCallback: extendedGamepadDelegate?.rightJoystickLeftPressed)
        configureHandlers(button: extendedGamepad.rightThumbstick.right, changedCallback: extendedGamepadDelegate?.rightJoystickRightChanged, pressedCallback: extendedGamepadDelegate?.rightJoystickRightPressed)
    }
    
    //MARK: Public
}
