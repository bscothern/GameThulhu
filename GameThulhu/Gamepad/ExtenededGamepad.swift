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
    
    private typealias Active = Bool
    
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
    
    private var buttonCallbacksActive: [ButtonType: Active] = [:]
    private var dPadCallbacksActive: [DirectionalPadType: Active] = [:]
    
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
        buttonCallbacksActive[.buttonA] = false
        buttonCallbacksActive[.buttonB] = false
        
        buttonCallbacksActive[.buttonX] = false
        buttonCallbacksActive[.buttonY] = false
        
        buttonCallbacksActive[.L1] = false
        buttonCallbacksActive[.L2] = false
        
        buttonCallbacksActive[.R1] = false
        buttonCallbacksActive[.R2] = false
        
        dPadCallbacksActive[.dPad] = false
        buttonCallbacksActive[.dPad(direction: .up)] = false
        buttonCallbacksActive[.dPad(direction: .down)] = false
        buttonCallbacksActive[.dPad(direction: .left)] = false
        buttonCallbacksActive[.dPad(direction: .right)] = false
        
        dPadCallbacksActive[.leftJoystick] = false
        buttonCallbacksActive[.leftJoystick(direction: .up)] = false
        buttonCallbacksActive[.leftJoystick(direction: .down)] = false
        buttonCallbacksActive[.leftJoystick(direction: .left)] = false
        buttonCallbacksActive[.leftJoystick(direction: .right)] = false
        
        dPadCallbacksActive[.rightJoystick] = false
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
        
        extendedGamepad.dpad.valueChangedHandler = createDPadCallback(type: .dPad)
        extendedGamepad.leftThumbstick.valueChangedHandler = createDPadCallback(type: .leftJoystick)
        extendedGamepad.rightThumbstick.valueChangedHandler = createDPadCallback(type: .rightJoystick)
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
    
    private func createDPadCallback(type: DirectionalPadType) -> (GCControllerDirectionPad, Float, Float) -> Void {
        return { [weak self](dPad: GCControllerDirectionPad, xValue: Float, yValue: Float) in
            guard let _self = self else {
                dPad.valueChangedHandler = nil
                return
            }
            
            let dPad = DirectionalPad(type: type, dPad: dPad)
            let callbackType: DirectionalPadCallbackType
            
            if (dPad.xAxis == 0 && dPad.yAxis == 0) {
                _self.dPadCallbacksActive[type] = false
                callbackType = .ended
            } else if _self.dPadCallbacksActive[type] == false {
                _self.dPadCallbacksActive[type] = true
                callbackType = .began
            } else {
                callbackType = .changed
            }
            
            UIResponder.raiseGamepadEvent(gamepad: _self, dPad: dPad, callbackType: callbackType)
        }
    }
    
    private func getGCControllerDirectionPad(type: DirectionalPadType) -> GCControllerDirectionPad{
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
