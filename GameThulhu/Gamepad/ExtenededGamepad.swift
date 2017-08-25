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
@objc public class ExtendedGamepad: Gamepad {
    //MARK:- Types
    //MARK: Private
    
    /// A helper class so each callback can keep its state without needing to protect it and have lock racing if lots of events are happening.
    private class Resting {
        /// When set to `false` the `Gamepad` element is not in the resting position. when `true` it is in the resting position.
        var value: Bool = false
    }
    
    //MARK:- Properties
    //MARK: Public
    
    /// The current view of the ExtendedGamepad's values.
    public var snapshot: ExtendedSnapshot {
        return ExtendedSnapshot(rawSnapshot)
    }
    
    /// The default snapshot object. It is usually wrapped into an `ExtendedSnapshot` to remove the clutter since they are immutable.
    public var rawSnapshot: GCExtendedGamepadSnapshot {
        return extendedGamepad.saveSnapshot()
    }
    
    //MARK: Private
    
    /// Used to access the GCExtendedGamepad for this object.
    private var extendedGamepad: GCExtendedGamepad {
        return controller.extendedGamepad!
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
    }
    
    //MARK:- Funcs
    //MARK: Public
    
    /// Use this function to change directional pad behavior between being a single `DirectionalPad` or 4 individual `Button` elements.
    ///
    /// When a directional pad is set to be a single `DirectionalPad` it uses the `EventResponder.gamepadDirectionalPad...` functions on the default UIResponder chain.
    ///
    /// When a directional pad is set to be 4 `Button` elements it uses the `EventResponder.gamepadButtonPress...` functions on the default UIResponder chain.
    ///
    /// - Parameters:
    ///   - dPadType: The `DirectionalPadType` that should have its behavior updated.
    ///   - actionType: The type of actions that the `dPadType` should take.
    public func use(dPadType: DirectionalPadType, as actionType: DirectionalPadActionType) {
        
        let dPad = getGCControllerDirectionPad(type: dPadType)
        
        switch actionType {
        case .dPad:
            dPad.makeButtonCallbacksNil()
            dPad.valueChangedHandler = createDPadHandler(type: dPadType)
        case .buttons:
            dPad.valueChangedHandler = nil
            dPad.up.valueChangedHandler = createButtonHandler(type: dPadType.asButton(direction: .up))
            dPad.down.valueChangedHandler = createButtonHandler(type: dPadType.asButton(direction: .down))
            dPad.left.valueChangedHandler = createButtonHandler(type: dPadType.asButton(direction: .left))
            dPad.right.valueChangedHandler = createButtonHandler(type: dPadType.asButton(direction: .right))
        }
    }
    
    //MARK: Private
    
    /// This will set up all of the default callbacks for the controller.
    private func configureCallbacks() {
        controller.controllerPausedHandler = pauseHandler
        
        extendedGamepad.buttonA.valueChangedHandler = createButtonHandler(type: .buttonA)
        extendedGamepad.buttonB.valueChangedHandler = createButtonHandler(type: .buttonB)
        
        extendedGamepad.buttonX.valueChangedHandler = createButtonHandler(type: .buttonX)
        extendedGamepad.buttonY.valueChangedHandler = createButtonHandler(type: .buttonY)
        
        extendedGamepad.leftShoulder.valueChangedHandler = createButtonHandler(type: .L1)
        extendedGamepad.leftTrigger.valueChangedHandler = createButtonHandler(type: .L2)
        
        extendedGamepad.rightShoulder.valueChangedHandler = createButtonHandler(type: .R1)
        extendedGamepad.rightTrigger.valueChangedHandler = createButtonHandler(type: .R2)
        
        extendedGamepad.dpad.valueChangedHandler = createDPadHandler(type: .dPad)
        extendedGamepad.leftThumbstick.valueChangedHandler = createDPadHandler(type: .leftJoystick)
        extendedGamepad.rightThumbstick.valueChangedHandler = createDPadHandler(type: .rightJoystick)
    }
    
    /// The pause button handler for the game controller. When it is called it raises the pause event on the default UIResponder chain.
    ///
    /// - Parameter controller: The Gamepad that has had its pause button pressed.
    private func pauseHandler(controller: GCController) {
        UIResponder.raiseGamepadPauseEvent(gamepad: self)
    }
    
    /// Creates an optomized `GCControllerButtonValueChangedHandler` for the specified `type` of button.
    ///
    /// - Parameter type: The type of button that should have a callback handler created.
    /// - Returns: A `GCControllerButtonValueChangedHandler` that handles change events for the specific `type` of button and puts the event on the default UIResponder chain.
    private func createButtonHandler(type: ButtonType) -> GCControllerButtonValueChangedHandler {
        
        // This will be captured and used as state in the closure.
        let resting = Resting()
        
        return { [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) in
            guard let _self = self else {
                    button.valueChangedHandler = nil
                    return
            }

            let button =  Button(type: type, button: button)
            let callbackType: ButtonCallbackType
            
            if (value == 0) {
                resting.value = true
                callbackType = .ended
            } else if resting.value {
                resting.value = false
                callbackType = .began
            } else {
                callbackType = .changed
            }
            
            UIResponder.raiseGamepadEvent(gamepad: _self, button: button, callbackType: callbackType)
        }
    }
    
    /// Creates an optomized `GCControllerDirectionPadValueChangedHandler` for the specified `type` of directional pad.
    ///
    /// - Parameter type: The type of directional pad that should have a callback handler created.
    /// - Returns: A `GCControllerDirectionPadValueChangedHandler` that handles change events for the specified `type` of directional pad and puts the event on the default UIResponder chain.
    private func createDPadHandler(type: DirectionalPadType) -> GCControllerDirectionPadValueChangedHandler {
        
        // This will be captured and used as state in the closure.
        let resting = Resting()
        
        return { [weak self](dPad: GCControllerDirectionPad, xValue: Float, yValue: Float) in
            guard let _self = self else {
                    dPad.valueChangedHandler = nil
                    return
            }
            
            let dPad = DirectionalPad(type: type, dPad: dPad)
            let callbackType: DirectionalPadCallbackType
            
            if (dPad.xAxis == 0 && dPad.yAxis == 0) {
                resting.value = true
                callbackType = .ended
            } else if resting.value {
                resting.value = false
                callbackType = .began
            } else {
                callbackType = .changed
            }
            
            UIResponder.raiseGamepadEvent(gamepad: _self, dPad: dPad, callbackType: callbackType)
        }
    }
    
    /// A convenience function to bridge a `DirectionalPadType` into the `GCControllerDirectionPad` it represents on the `extendedGamepad`.
    ///
    /// - Parameter type: The `DirectionalPadType` that is desired from the `extendedGamepad`.
    /// - Returns: A `GCControllerDirectionaPad` from the `extendedGamepad` that is the `type` specified.
    private func getGCControllerDirectionPad(type: DirectionalPadType) -> GCControllerDirectionPad {
        switch type {
        case .dPad:
            return extendedGamepad.dpad
        case .leftJoystick:
            return extendedGamepad.leftThumbstick
        case .rightJoystick:
            return extendedGamepad.rightThumbstick
        }
    }
}

fileprivate extension GCControllerDirectionPad {
    /// A convenience function that makes all 4 buttons of the GCControllerDirectionalPad have `nil` as their `valueChangedHandler`.
    func makeButtonCallbacksNil() {
        up.valueChangedHandler = nil
        down.valueChangedHandler = nil
        left.valueChangedHandler = nil
        right.valueChangedHandler = nil
    }
}
