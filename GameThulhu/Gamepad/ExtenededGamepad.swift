//
//  ExtendededGamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// This is a wrapper around GCExtendedGamepad that makes it easier to work with. It sets up all `EventResponder` callbacks.
///
/// -Note:
///     Since all `DirectionalPadType` can also be worked with as 4 buttons, you will need to tell the `ExtendedGamepad` which of
///     these should be considered a `ButtonType` instead. This changed via `useDirectionalPad(dPad: DirectionalPadType , as: DirectionalPadActionType)`
@objc public class ExtendedGamepad: Gamepad {
    //MARK:- Types
    //MARK: Private
    
    private typealias Active = Bool
    
    //MARK: Public
    
//    /// Use `ButtonProperty` values to have a button watch for a specific property and receive that value along with its callbacks.
//    public enum ButtonProperty {
//        case pressedDuration
//    }
//
//    /// The value of a `ButtonProperty` wrapped up so it can be identified and strongly typed.
//    public enum ButtonPropertyValue {
//        case pressedDuration(duration: TimeInterval)
//    }
    
    //MARK:- Properties
    //MARK: Private
    
    /// Used to access the GCExtendedGamepad for this object.
    private var extendedGamepad: GCExtendedGamepad {
        return controller.extendedGamepad!
    }
    
    private var buttonCallbacksActive: [ButtonType: Active] = [:]
    
    
//    /// Used to protect `buttonPropertyMap`.
//    private let buttonPropertyMapLock = NSRecursiveLock()
//
//    /// Used to keep track of the properties to observe for buttons.
//    /// - Note: Protected by `buttonPropertyMapLock`.
//    private var buttonPropertyMap: [ButtonType: Set<ButtonProperty>] = [:]
    
    //MARK: Public
    
    /// The current view of the ExtendedGamepad's values.
    public var snapshot: ExtendedSnapshot {
        return ExtendedSnapshot(rawSnapshot)
    }
    
    /// The default snapshot object. It is usually wrapped into an `ExtendedSnapshot` to remove the clutter since they are immutable.
    public var rawSnapshot: GCExtendedGamepadSnapshot {
        return extendedGamepad.saveSnapshot()
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
        
        configureCallbacks()
//        for button: ButtonElement in [ButtonElement.buttonA, ButtonElement.buttonB,
//                               ButtonElement.buttonX, ButtonElement.buttonY,
//                               ButtonElement.L1, ButtonElement.L2,
//                               ButtonElement.R1, ButtonElement.R2,
//                               ButtonElement.dPad(direction: .up), ButtonElement.dPad(direction: .down),
//                               ButtonElement.dPad(direction: .left), ButtonElement.dPad(direction: .right),
//                               ButtonElement.leftJoystick(direction: .up), ButtonElement.leftJoystick(direction: .down),
//                               ButtonElement.leftJoystick(direction: .left), ButtonElement.leftJoystick(direction: .right),
//                               ButtonElement.rightJoystick(direction: .up), ButtonElement.rightJoystick(direction: .down),
//                               ButtonElement.rightJoystick(direction: .left), ButtonElement.rightJoystick(direction: .right)] {
//            buttonActionMap[button] = .changed
//        }
    }
    
    //MARK:- Funcs
    //MARK: Private
    
    /// This will set up all of the default callbacks for the controller.
    private func configureCallbacks() {
        buttonCallbacksActive[.buttonA] = false
        buttonCallbacksActive[.buttonB] = false
        
        buttonCallbacksActive[.buttonX] = false
        buttonCallbacksActive[.buttonY] = false
        
        buttonCallbacksActive[.L1] = false
        buttonCallbacksActive[.L2] = false
        
        buttonCallbacksActive[.R1] = false
        buttonCallbacksActive[.R2] = false
        
        buttonCallbacksActive[.dPad(direction: .up)] = false
        buttonCallbacksActive[.dPad(direction: .down)] = false
        buttonCallbacksActive[.dPad(direction: .left)] = false
        buttonCallbacksActive[.dPad(direction: .right)] = false
        
        buttonCallbacksActive[.leftJoystick(direction: .up)] = false
        buttonCallbacksActive[.leftJoystick(direction: .down)] = false
        buttonCallbacksActive[.leftJoystick(direction: .left)] = false
        buttonCallbacksActive[.leftJoystick(direction: .right)] = false
        
        buttonCallbacksActive[.rightJoystick(direction: .up)] = false
        buttonCallbacksActive[.rightJoystick(direction: .down)] = false
        buttonCallbacksActive[.rightJoystick(direction: .left)] = false
        buttonCallbacksActive[.rightJoystick(direction: .right)] = false
        
        extendedGamepad.buttonA.valueChangedHandler = createButtonCallback(type: .buttonA)
        extendedGamepad.buttonB.valueChangedHandler = createButtonCallback(type: .buttonB)
        
        extendedGamepad.buttonX.valueChangedHandler = createButtonCallback(type: .buttonX)
        extendedGamepad.buttonY.valueChangedHandler = createButtonCallback(type: .buttonY)
        
        extendedGamepad.leftShoulder.valueChangedHandler = createButtonCallback(type: .L1)
        extendedGamepad.leftTrigger.valueChangedHandler = createButtonCallback(type: .L2)
        
        extendedGamepad.rightShoulder.valueChangedHandler = createButtonCallback(type: .R1)
        extendedGamepad.rightTrigger.valueChangedHandler = createButtonCallback(type: .R2)
    }
    
    private func createButtonCallback(type: ButtonType) -> (GCControllerButtonInput, Float, Bool) -> Void {
        return { [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) in
            guard let _self = self else {
                button.valueChangedHandler = nil
                return
            }
            
            let button =  Button(type: type, button: button)
            let callbackType: ButtonCallbackType
            
            if (value == 0) {
                _self.buttonCallbacksActive[type] = false
                callbackType = .ended
            } else if _self.buttonCallbacksActive[type] == false {
                _self.buttonCallbacksActive[type] = true
                callbackType = .began
            } else {
                callbackType = .changed
            }
            
            UIResponder.raiseGamepadEvent(gamepad: _self, button: button, callbackType: callbackType)
        }
    }
}




    //MARK:- Funcs
    //MARK: Private
    
//    /// Used to assign `nil` to all callbacks on a button.
//    ///
//    /// - Parameter button: The `GCControllerButtonInput` which should have its callbacks set to `nil`.
//    private func nilifyCalbacks(buttons: [GCControllerButtonInput]) {
//        for button in buttons {
//            button.valueChangedHandler = nil
//        }
//    }
//
//    /// Used to assign `nil` to all callbacks on a directional pad, including its button elements.
//    ///
//    /// - Parameter dPad: The `GCControllerDirectionPad` which should have its callbacks set to `nil`.
//    private func nilifyCalbacks(dPads: [GCControllerDirectionPad]) {
//        for dPad in dPads {
//            nilifyCalbacks(buttons: [dPad.up, dPad.down, dPad.left, dPad.right])
//            dPad.valueChangedHandler = nil
//        }
//    }
//
//    /// Sets up the callback for the `gcButton` while making sure it only sets it if valid.
//    ///
//    /// The callback set depends on the value of `buttonActionMap` so for performance reasons you should protect it before calling this function.
//    ///
//    /// - Parameters:
//    ///   - button: The `ButtonElement` that is being modified.
//    ///   - gcButton: The actual `GCControllerButtonInput` being modified.
//    ///   - callback: The callback function for the `gcButton`.
//    @inline(__always) private func configureHandlers(button: ButtonElement, gcButton: GCControllerButtonInput, callback: ExtendedGamepadDelegate.ButtonCallback?) {
//        switch buttonActionMap[button]! {
//        case .changed:
//            gcButton.pressedChangedHandler = nil
//            gcButton.valueChangedHandler = (callback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
//                guard let _self = self else {
//                    button.valueChangedHandler = nil
//                    return
//                }
//                callback?(_self, value, pressed, properties)
//            }
//
//        case .pressed:
//            gcButton.valueChangedHandler = nil
//            gcButton.pressedChangedHandler = (callback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
//                guard let _self = self else {
//                    button.pressedChangedHandler = nil
//                    return
//                }
//                callback?(_self, value, pressed, properties)
//            }
//        }
//    }
//
//    /// Sets up the callback for the `gcDPad` while making sure it is valid.
//    ///
//    /// - Parameters:
//    ///   - gcDPad: The `GCControllerDirectionaPad` that is being modified.
//    ///   - callback: The callback function for the `gcDPad`.
//    @inline(__always) private func configureHandlers(gcDPad: GCControllerDirectionPad, callback: ExtendedGamepadDelegate.DirectionalPadCallback?) {
//        gcDPad.valueChangedHandler = (callback == nil) ? nil:{ [weak self](dpad: GCControllerDirectionPad, xValue: Float, yValue: Float) -> Void in
//            guard let _self = self else {
//                dpad.valueChangedHandler = nil
//                return
//            }
//            callback?(_self, xValue, yValue)
//        }
//    }
//
//    /// Sets up all of the callbacks for the `ExtendedGamepad` with the current delegate values.
//    private func configureExtendedGamepadDelegate() {
//        //MARK: Verify extendedGamepadDelegate
//        guard extendedGamepadDelegate != nil else {
//            nilifyCalbacks(buttons: [extendedGamepad.buttonA, extendedGamepad.buttonB, extendedGamepad.buttonX, extendedGamepad.buttonY,
//                                     extendedGamepad.leftShoulder, extendedGamepad.leftTrigger, extendedGamepad.rightShoulder, extendedGamepad.rightTrigger])
//            nilifyCalbacks(dPads: [extendedGamepad.dpad, extendedGamepad.leftThumbstick, extendedGamepad.rightThumbstick])
//            return
//        }
//
//        buttonActionMapLock.execute {
//            //MARK: Configure Button Callbacks
//            configureHandlers(button: .buttonA, gcButton: extendedGamepad.buttonA, callback: extendedGamepadDelegate?.buttonA)
//            configureHandlers(button: .buttonB, gcButton: extendedGamepad.buttonB, callback: extendedGamepadDelegate?.buttonB)
//            configureHandlers(button: .buttonX, gcButton: extendedGamepad.buttonX, callback: extendedGamepadDelegate?.buttonX)
//            configureHandlers(button: .buttonY, gcButton: extendedGamepad.buttonY, callback: extendedGamepadDelegate?.buttonY)
//
//            //MARK: Configure Trigger Button Callbacks
//            configureHandlers(button: .L1, gcButton: extendedGamepad.leftShoulder, callback: extendedGamepadDelegate?.L1)
//            configureHandlers(button: .L2, gcButton: extendedGamepad.leftTrigger, callback: extendedGamepadDelegate?.L2)
//            configureHandlers(button: .R1, gcButton: extendedGamepad.rightShoulder, callback: extendedGamepadDelegate?.R1)
//            configureHandlers(button: .R2, gcButton: extendedGamepad.rightTrigger, callback: extendedGamepadDelegate?.R2)
//
//            //MARK: Configure DPad
//            configureHandlers(gcDPad: extendedGamepad.dpad, callback: extendedGamepadDelegate?.dPad)
//            configureHandlers(button: .dPad(direction: .up), gcButton: extendedGamepad.dpad.up, callback: extendedGamepadDelegate?.dPadUp)
//            configureHandlers(button: .dPad(direction: .down), gcButton: extendedGamepad.dpad.down, callback: extendedGamepadDelegate?.dPadDown)
//            configureHandlers(button: .dPad(direction: .left), gcButton: extendedGamepad.dpad.left, callback: extendedGamepadDelegate?.dPadLeft)
//            configureHandlers(button: .dPad(direction: .right), gcButton: extendedGamepad.dpad.right, callback: extendedGamepadDelegate?.dPadRight)
//
//            //MARK: Configure Left Joystick
//            configureHandlers(gcDPad: extendedGamepad.leftThumbstick, callback: extendedGamepadDelegate?.leftJoystick)
//            configureHandlers(button: .leftJoystick(direction: .up), gcButton: extendedGamepad.leftThumbstick.up, callback: extendedGamepadDelegate?.leftJoystickUp)
//            configureHandlers(button: .leftJoystick(direction: .down), gcButton: extendedGamepad.leftThumbstick.down, callback: extendedGamepadDelegate?.leftJoystickDown)
//            configureHandlers(button: .leftJoystick(direction: .left), gcButton: extendedGamepad.leftThumbstick.left, callback: extendedGamepadDelegate?.leftJoystickLeft)
//            configureHandlers(button: .leftJoystick(direction: .right), gcButton: extendedGamepad.leftThumbstick.right, callback: extendedGamepadDelegate?.leftJoystickRight)
//
//            //MARK: Configure Right Joystick
//            configureHandlers(gcDPad: extendedGamepad.rightThumbstick, callback: extendedGamepadDelegate?.rightJoystick)
//            configureHandlers(button: .rightJoystick(direction: .up), gcButton: extendedGamepad.rightThumbstick.up, callback: extendedGamepadDelegate?.rightJoystickUp)
//            configureHandlers(button: .rightJoystick(direction: .down), gcButton: extendedGamepad.rightThumbstick.down, callback: extendedGamepadDelegate?.rightJoystickDown)
//            configureHandlers(button: .rightJoystick(direction: .left), gcButton: extendedGamepad.rightThumbstick.left, callback: extendedGamepadDelegate?.rightJoystickLeft)
//            configureHandlers(button: .rightJoystick(direction: .right), gcButton: extendedGamepad.rightThumbstick.right, callback: extendedGamepadDelegate?.rightJoystickRight)
//        }
//    }
//
//    //MARK: Public
//    /// This is used to cahnge the `Action` that a `button` acts upon for its callback.
//    ///
//    /// The default value is always `Action.changed`. If you modify it with this it will be persistent across different delegate assignments.
//    ///
//    /// - Parameters:
//    ///   - button: The `ButtonElement` that should have its callback action modified.
//    ///   - action: The `Action` that should trigger a callback for the `button`.
//    public func set(button: ButtonElement, action: Action) {
//        buttonActionMapLock.execute {
//            buttonActionMap[button] = action
//            configureHandlers(button: button, gcButton: extendedGamepad.get(button: button), callback: extendedGamepadDelegate?.get(button: button))
//        }
//    }
//}
//
//fileprivate extension GCExtendedGamepad {
//    /// Bridges a `ExtendedGamepad.ButtonElement` into the correct `GCControllerButtonInput` from the `GCExtendedGamepad`.
//    ///
//    /// - Parameter button: The `ButtonElement` that is desired from the `GCExtendedGamepad`.
//    /// - Returns: The `GCControllerButtonInput` that maps to the given `button`.
//    func get(button: ExtendedGamepad.ButtonElement) -> GCControllerButtonInput {
//        switch button {
//        case .buttonA:
//            return buttonA
//        case .buttonB:
//            return buttonB
//        case .buttonX:
//            return buttonX
//        case .buttonY:
//            return buttonY
//
//        case .L1:
//            return leftShoulder
//        case .L2:
//            return leftTrigger
//        case .R1:
//            return rightShoulder
//        case .R2:
//            return rightTrigger
//
//        case .dPad(let direction):
//            return dpad.get(direction: direction)
//        case .leftJoystick(let direction):
//            return leftThumbstick.get(direction: direction)
//        case .rightJoystick(let direction):
//            return rightThumbstick.get(direction: direction)
//        }
//    }
//}

//fileprivate extension GCControllerDirectionPad {
//
//    /// Bridge a `ExtendedGamepad.ButtonElement.Direction` from a `GCControllerDirectionalPad` to the `GCControllerButtonInput` of that directional pad.
//    ///
//    /// - Parameter direction: The direction desired from the `GCControllerDirectionalPad`.
//    /// - Returns: THe `GCControllerButtonInput` from the `GCControllerDirectionalPad` thata matches the given `direction`.
//    func get(direction: ExtendedGamepad.ButtonElement.Direction) -> GCControllerButtonInput {
//        switch direction {
//        case .up:
//            return up
//        case .down:
//            return down
//        case .left:
//            return left
//        case .right:
//            return right
//        }
//    }
//}
//
//fileprivate extension ExtendedGamepadDelegate {
//
//    /// Attempt to get the callback from the `ExtendedGamepadDelegate` for a given `button`.
//    ///
//    /// - Parameter button: The `ButtonElement` that has the desired callback
//    /// - Returns: An `ExtendedGamepadDelegate.ButtonCallback` that matches the given `button` if it is implemented, `nil` otherwise.
//    func get(button: ExtendedGamepad.ButtonElement) -> ExtendedGamepadDelegate.ButtonCallback? {
//        switch button {
//        case .buttonA:
//            return buttonA
//        case .buttonB:
//            return buttonB
//        case .buttonX:
//            return buttonX
//        case .buttonY:
//            return buttonY
//
//        case .L1:
//            return L1
//        case .L2:
//            return L2
//        case .R1:
//            return R1
//        case .R2:
//            return R2
//
//        case .dPad(let direction):
//            switch direction {
//            case .up:
//                return dPadUp
//            case .down:
//                return dPadDown
//            case .left:
//                return dPadLeft
//            case .right:
//                return dPadRight
//            }
//
//        case .leftJoystick(let direction):
//            switch direction {
//            case .up:
//                return leftJoystickUp
//            case .down:
//                return leftJoystickDown
//            case .left:
//                return leftJoystickLeft
//            case .right:
//                return leftJoystickRight
//            }
//
//        case .rightJoystick(let direction):
//                switch direction {
//                case .up:
//                    return rightJoystickUp
//                case .down:
//                    return rightJoystickDown
//                case .left:
//                    return rightJoystickLeft
//                case .right:
//                    return rightJoystickRight
//            }
//        }
//    }
//}

