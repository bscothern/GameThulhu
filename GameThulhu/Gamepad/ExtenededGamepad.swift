//
//  ExtenededGamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

public protocol ExtendedGamepadElement {
    func gcElement(gamepad: GCExtendedGamepad) ->  GCControllerElement
}

/// A wrapper for `GCController` that can only be constructed if the given `GCController` is a `GCExtendedGamepad`. It provides lots of convenient functionality for interactions with the gamepad.
public class ExtendedGamepad: Gamepad {
    //MARK:- Types
    
    /**
     A funciton that will be called when a value changes on a gamepad.
     
     - parameters:
        - gamepad: The `ExtendedGamepad` that had it's value change
        - element: The `ExtendedGamepad.Element` that has changed.
     */
    public typealias ValueChangeCallback = (_ gamepad: ExtendedGamepad, _ element: ExtendedGamepadElement) -> Void
    
    public typealias OnButtonChangeCallback = (_ gamepad: ExtendedGamepad, _ element: ButtonElement, _ value: Float, _  pressed: Bool) -> Void
    
    public typealias OnDirectionalPadChangeCallback = (_ gamepad: ExtendedGamepad, _ element: DirectionalPadElement, _ xValue: Float, _  yValue: Float) -> Void
    
    // (GCControllerButtonInput, Float, Bool)
    
    /// A `CallbackIdentifier` is given when adding a new callback. It can be used to remove the callback.
    public typealias CallbackIdentifier = UUID
    
    /// Elements that can be interacted with on an `ExtendedGamepad` controller's `Button`s.
    public enum ButtonElement: ExtendedGamepadElement {
        /// The **A** button on a controller
        case buttonA
        /// The **B** button on a controller
        case buttonB
        /// The **X** button on a controller
        case buttonX
        /// The **Y** button on a controller
        case buttonY
        
        /// The **L1** bumper on a controller
        case L1
        /// The **L2** trigger on a controller
        case L2
        /// The **R1** bumper on a controller
        case R1
        /// The **R2** trigger on a controller
        case R2
        
        /// The **Up** button on a D-Pad
        case dPadUp
        /// The **Down** button on a D-Pad
        case dPadDown
        /// The **Left** button on a D-Pad
        case dPadLeft
        /// The **Right** button on a D-Pad
        case dPadRight
        
        /// The **Up** component of the **Left Joystick** on a controller
        case leftJoystickUp
        /// The **Down** component of the **Left Joystick** on a controller
        case leftJoystickDown
        /// The **Left** component of the **Left Joystick** on a controller
        case leftJoystickLeft
        /// The **Right** component of the **Left Joystick** on a controller
        case leftJoystickRight
        
        /// The **Up** component of the **Right Joystick** on a controller
        case rightJoystickUp
        /// The **Down** component of the **Right Joystick** on a controller
        case rightJoystickDown
        /// The **Left** component of the **Right Joystick** on a controller
        case rightJoystickLeft
        /// The **Right** component of the **Right Joystick** on a controller
        case rightJoystickRight
        
        public func gcElement(gamepad: GCExtendedGamepad) ->  GCControllerElement {
            switch self {
            case .buttonA:
                return gamepad.buttonA
            case .buttonB:
                return gamepad.buttonB
            case .buttonX:
                return gamepad.buttonX
            case .buttonY:
                return gamepad.buttonY
                
            case .L1:
                return gamepad.leftShoulder
            case .L2:
                return gamepad.leftTrigger
            case .R1:
                return gamepad.rightShoulder
            case .R2:
                return gamepad.rightTrigger
            
            case .dPadUp:
                return gamepad.dpad.up
            case .dPadDown:
                return gamepad.dpad.down
            case .dPadLeft:
                return gamepad.dpad.left
            case .dPadRight:
                return gamepad.dpad.right
            
            case .leftJoystickUp:
                return gamepad.leftThumbstick.up
            case .leftJoystickDown:
                return gamepad.leftThumbstick.down
            case .leftJoystickLeft:
                return gamepad.leftThumbstick.left
            case .leftJoystickRight:
                return gamepad.leftThumbstick.right

            case .rightJoystickUp:
                return gamepad.rightThumbstick.up
            case .rightJoystickDown:
                return gamepad.rightThumbstick.down
            case .rightJoystickLeft:
                return gamepad.rightThumbstick.left
            case .rightJoystickRight:
                return gamepad.rightThumbstick.right
            }
        }
    }
    
    public enum DirectionalPadElement: ExtendedGamepadElement {
        /// The **D-Pad** on a controller
        case dPad
        /// The **Left Joystick** on a controller
        case leftJoystick
        /// The **Right Joystick** on a controller
        case rightJoystick
        
        public func gcElement(gamepad: GCExtendedGamepad) ->  GCControllerElement {
            switch self {
            case .dPad:
                return gamepad.dpad
            case .leftJoystick:
                return gamepad.leftThumbstick
            case .rightJoystick:
                return gamepad.rightThumbstick
            }
        }
    }
    
    //MARK:- Properties
    //MARK: Private
    /// Used to access the GCExtendedGamepad for this object.
    fileprivate var extendedGamepad: GCExtendedGamepad {
        return controller.extendedGamepad!
    }
    
    /// Used to protect `var valueChangedCallbacks`.
    private let valueChangedCallbacksLock = NSLock()
    /// This dictionary is used to keep track of value changed callbacks in such a way that they can be removed if desired.
    private var valueChangedCallbacks: [CallbackIdentifier: ValueChangeCallback] = [:]
    
    /// Used to protect `var onChangeCallbacks`.
    private let onChangeCallbacksLock = NSLock()
    /// This dictionary is used to keep track of callbacks for On Change events in such a way they can be removed if desired
    private var onChangeCallbacks: [CallbackIdentifier: OnButtonChangeCallback] = [:]
    
    /// Used to bridge GCControlerElement's to the element type quickly.
    private var elementMap: [HashableWeakVar<GCControllerElement>: ExtendedGamepadElement] = [:]
    
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
    
    /**
     Creates an `ExtendedController` if the given `GCController` is an `GCExtendedGamepad`.
     
     - parameters:
        - controller: The `GCController` which this `ExtendedController` should use. If the property `extendedGampead` returns `nil` this constructor will fail.
     */
    public override init?(controller: GCController) {
        guard controller.extendedGamepad != nil else {
            return nil
        }
        super.init(controller: controller)
        
        let gamepad = extendedGamepad
        elementMap[gamepad.buttonA] = ButtonElement.buttonA
        elementMap[gamepad.buttonB] = ButtonElement.buttonB
        elementMap[gamepad.buttonX] = ButtonElement.buttonX
        elementMap[gamepad.buttonY] = ButtonElement.buttonY
        
        elementMap[gamepad.leftShoulder] = ButtonElement.L1
        elementMap[gamepad.leftTrigger] = ButtonElement.L2
        elementMap[gamepad.rightShoulder] = ButtonElement.R1
        elementMap[gamepad.rightTrigger] = ButtonElement.R2
        
        elementMap[gamepad.dpad.up] = ButtonElement.dPadUp
        elementMap[gamepad.dpad.down] = ButtonElement.dPadDown
        elementMap[gamepad.dpad.left] = ButtonElement.dPadLeft
        elementMap[gamepad.dpad.right] = ButtonElement.dPadRight
        
        elementMap[gamepad.leftThumbstick.up] = ButtonElement.leftJoystickUp
        elementMap[gamepad.leftThumbstick.down] = ButtonElement.leftJoystickDown
        elementMap[gamepad.leftThumbstick.left] = ButtonElement.leftJoystickLeft
        elementMap[gamepad.leftThumbstick.right] = ButtonElement.leftJoystickRight
        
        elementMap[gamepad.rightThumbstick.up] = ButtonElement.rightJoystickUp
        elementMap[gamepad.rightThumbstick.down] = ButtonElement.rightJoystickDown
        elementMap[gamepad.rightThumbstick.left] = ButtonElement.rightJoystickLeft
        elementMap[gamepad.rightThumbstick.right] = ButtonElement.rightJoystickRight
        
        elementMap[gamepad.dpad] = DirectionalPadElement.dPad
        elementMap[gamepad.leftThumbstick] = DirectionalPadElement.leftJoystick
        elementMap[gamepad.rightThumbstick] = DirectionalPadElement.rightJoystick
    }
    
    //MARK:- Funcs
    public func onValueChange(callback: @escaping ValueChangeCallback) -> CallbackIdentifier {
        return valueChangedCallbacksLock.valuedExecute {
            let callbackID = CallbackIdentifier()
            self.valueChangedCallbacks[callbackID] = callback
            
            if self.valueChangedCallbacks.count == 1 {
                self.extendedGamepad.valueChangedHandler = onValueChangeHandler
            }
            
            return callbackID
        }
    }
    
    private func onValueChangeHandler(gamepad: GCExtendedGamepad, gcElement: GCControllerElement) {
        let callbacks = self.valueChangedCallbacksLock.valuedExecute { self.valueChangedCallbacks }
        
        guard let element = self.elementMap[gcElement] ?? gcElement.elementTypeFrom(gamepad: self.extendedGamepad) else {
            return
        }
        
        for callback in callbacks.values {
            callback(self, element)
        }
    }
    
    public func onChange(button: ButtonElement, callback: @escaping OnButtonChangeCallback) -> CallbackIdentifier {
        guard let gcButton = button.gcElement(gamepad: extendedGamepad) as? GCControllerButtonInput else {
            fatalError("ButtonElement has returned an element that wasnt a GCControllerButtonInput")
        }
        
        return onChangeCallbacksLock.valuedExecute {
            let callbackId = CallbackIdentifier()
            self.onChangeCallbacks[callbackId] = callback
            
            if self.valueChangedCallbacks.count == 1 {
                gcButton.valueChangedHandler = onChangeButtonHandler
            }
        
            return callbackId
        }
    }
    
    private func onChangeButtonHandler(gcElement: GCControllerButtonInput, value: Float, pressed: Bool) {
        let callbacks = self.onChangeCallbacksLock.valuedExecute { self.onChangeCallbacks }
        
        guard let element = (self.elementMap[gcElement] ?? gcElement.elementTypeFrom(gamepad: extendedGamepad)) as? ButtonElement else {
            fatalError("Unable to convert gcElement into ButtonElement")
        }
        
        for callback in callbacks.values {
            callback(self, element, value, pressed)
        }
    }
}

fileprivate extension GCControllerElement {
    func elementTypeFrom(gamepad: GCExtendedGamepad) -> ExtendedGamepadElement? {
        switch self {
        case gamepad.buttonA:
            return ExtendedGamepad.ButtonElement.buttonA
        case gamepad.buttonB:
            return ExtendedGamepad.ButtonElement.buttonB
        case gamepad.buttonX:
            return ExtendedGamepad.ButtonElement.buttonX
        case gamepad.buttonY:
            return ExtendedGamepad.ButtonElement.buttonY
        
        case gamepad.leftShoulder:
            return ExtendedGamepad.ButtonElement.L1
        case gamepad.leftTrigger:
            return ExtendedGamepad.ButtonElement.L2
        case gamepad.rightShoulder:
            return ExtendedGamepad.ButtonElement.R1
        case gamepad.rightTrigger:
            return ExtendedGamepad.ButtonElement.R2
        
        case gamepad.dpad.up:
            return ExtendedGamepad.ButtonElement.dPadUp
        case gamepad.dpad.down:
            return ExtendedGamepad.ButtonElement.dPadDown
        case gamepad.dpad.left:
            return ExtendedGamepad.ButtonElement.dPadLeft
        case gamepad.dpad.right:
            return ExtendedGamepad.ButtonElement.dPadRight
            
        case gamepad.leftThumbstick.up:
            return ExtendedGamepad.ButtonElement.leftJoystickUp
        case gamepad.leftThumbstick.down:
            return ExtendedGamepad.ButtonElement.leftJoystickDown
        case gamepad.leftThumbstick.left:
            return ExtendedGamepad.ButtonElement.leftJoystickLeft
        case gamepad.leftThumbstick.right:
            return ExtendedGamepad.ButtonElement.leftJoystickRight
        
        case gamepad.rightThumbstick.up:
            return ExtendedGamepad.ButtonElement.rightJoystickUp
        case gamepad.rightThumbstick.down:
            return ExtendedGamepad.ButtonElement.rightJoystickDown
        case gamepad.rightThumbstick.left:
            return ExtendedGamepad.ButtonElement.rightJoystickLeft
        case gamepad.rightThumbstick.right:
            return ExtendedGamepad.ButtonElement.rightJoystickRight
        
        case gamepad.dpad:
            return ExtendedGamepad.DirectionalPadElement.dPad
        case gamepad.leftThumbstick:
            return ExtendedGamepad.DirectionalPadElement.leftJoystick
        case gamepad.rightThumbstick:
            return ExtendedGamepad.DirectionalPadElement.rightJoystick
            
        default:
            return nil
        }
    }
}

fileprivate extension Dictionary where Dictionary.Key == HashableWeakVar<GCControllerElement> {
    subscript(rawKey: GCControllerElement) -> Dictionary.Value? {
        get {
            return self[HashableWeakVar(rawKey)]
        }
        mutating set {
            self[HashableWeakVar(rawKey)] = newValue
        }
    }
}




