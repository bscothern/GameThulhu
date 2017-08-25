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
/// - Note:
///     Since all `DirectionalPadType` can also be worked with as 4 buttons, you will need to tell the `ExtendedGamepad` which of
///     these should be considered a `ButtonType` instead. This can be changed via `use(dPadType:, as:)`.
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
    
    /// Keeps track which buttons are in their resting position.
    private var buttonCallbacksResting: [ButtonType: Resting] = [:]

    /// Keeps track of which D-Pads are in their resting position.
    private var dPadCallbacksResting: [DirectionalPadType: Resting] = [:]
    
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
            dPad.valueChangedHandler = createDPadCallback(type: dPadType)
        case .buttons:
            dPad.valueChangedHandler = nil
            dPad.up.valueChangedHandler = createButtonCallback(type: dPadType.asButton(direction: .up))
            dPad.down.valueChangedHandler = createButtonCallback(type: dPadType.asButton(direction: .down))
            dPad.left.valueChangedHandler = createButtonCallback(type: dPadType.asButton(direction: .left))
            dPad.right.valueChangedHandler = createButtonCallback(type: dPadType.asButton(direction: .right))
        }
    }
    
    //MARK: Private
    
    /// This will set up all of the default callbacks for the controller.
    private func configureCallbacks() {
        buttonCallbacksResting[.buttonA] = Resting()
        buttonCallbacksResting[.buttonB] = Resting()
        
        buttonCallbacksResting[.buttonX] = Resting()
        buttonCallbacksResting[.buttonY] = Resting()
        
        buttonCallbacksResting[.L1] = Resting()
        buttonCallbacksResting[.L2] = Resting()
        
        buttonCallbacksResting[.R1] = Resting()
        buttonCallbacksResting[.R2] = Resting()
        
        dPadCallbacksResting[.dPad] = Resting()
        buttonCallbacksResting[.dPad(direction: .up)] = Resting()
        buttonCallbacksResting[.dPad(direction: .down)] = Resting()
        buttonCallbacksResting[.dPad(direction: .left)] = Resting()
        buttonCallbacksResting[.dPad(direction: .right)] = Resting()
        
        dPadCallbacksResting[.leftJoystick] = Resting()
        buttonCallbacksResting[.leftJoystick(direction: .up)] = Resting()
        buttonCallbacksResting[.leftJoystick(direction: .down)] = Resting()
        buttonCallbacksResting[.leftJoystick(direction: .left)] = Resting()
        buttonCallbacksResting[.leftJoystick(direction: .right)] = Resting()
        
        dPadCallbacksResting[.rightJoystick] = Resting()
        buttonCallbacksResting[.rightJoystick(direction: .up)] = Resting()
        buttonCallbacksResting[.rightJoystick(direction: .down)] = Resting()
        buttonCallbacksResting[.rightJoystick(direction: .left)] = Resting()
        buttonCallbacksResting[.rightJoystick(direction: .right)] = Resting()
        
        controller.controllerPausedHandler = pauseHandler
        
        extendedGamepad.buttonA.valueChangedHandler = createButtonCallback(type: .buttonA)
        extendedGamepad.buttonB.valueChangedHandler = createButtonCallback(type: .buttonB)
        
        extendedGamepad.buttonX.valueChangedHandler = createButtonCallback(type: .buttonX)
        extendedGamepad.buttonY.valueChangedHandler = createButtonCallback(type: .buttonY)
        
        extendedGamepad.leftShoulder.valueChangedHandler = createButtonCallback(type: .L1)
        extendedGamepad.leftTrigger.valueChangedHandler = createButtonCallback(type: .L2)
        
        extendedGamepad.rightShoulder.valueChangedHandler = createButtonCallback(type: .R1)
        extendedGamepad.rightTrigger.valueChangedHandler = createButtonCallback(type: .R2)
        
        extendedGamepad.dpad.valueChangedHandler = createDPadCallback(type: .dPad)
        extendedGamepad.leftThumbstick.valueChangedHandler = createDPadCallback(type: .leftJoystick)
        extendedGamepad.rightThumbstick.valueChangedHandler = createDPadCallback(type: .rightJoystick)
    }
    
    private func pauseHandler(controller: GCController) {
        UIResponder.raiseGamepadPauseEvent(gamepad: self)
    }
    
    private func createButtonCallback(type: ButtonType) -> (GCControllerButtonInput, Float, Bool) -> Void {
        let resting = buttonCallbacksResting[type]!
        
        return { [weak self, weak resting](button: GCControllerButtonInput, value: Float, pressed: Bool) in
            guard let _self = self,
                let resting = resting
                else {
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
    
    private func createDPadCallback(type: DirectionalPadType) -> (GCControllerDirectionPad, Float, Float) -> Void {
        let resting = dPadCallbacksResting[type]!
        
        return { [weak self, weak resting](dPad: GCControllerDirectionPad, xValue: Float, yValue: Float) in
            guard let _self = self,
                let resting = resting
                else {
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
    func makeButtonCallbacksNil() {
        up.valueChangedHandler = nil
        down.valueChangedHandler = nil
        left.valueChangedHandler = nil
        right.valueChangedHandler = nil
    }
}
