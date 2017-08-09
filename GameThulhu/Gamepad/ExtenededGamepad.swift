//
//  ExtenededGamepad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation
import GameController

/// A wrapper for `GCController` that can only be constructed if the given `GCController` is a `GCExtendedGamepad`. It provides lots of convenient functionality for interactions with the gamepad.
public class ExtendedGamepad: Gamepad {
    //MARK:- Types
    
    /// A funciton that will be called when a value changes on any `ExtendedGamepad.Element`.
    ///
    /// - parameters:
    ///     - gamepad: The `ExtendedGamepad` that had a value change
    ///     - element: The `ExtendedGamepad.Element` that has changed.
    public typealias ValueChangeCallback = (_ gamepad: ExtendedGamepad, _ element: ExtendedGamepad.Element) -> Void
    
    /// A function that will be called when a value changes on any `ExtendedGamepad.ButtonElement`.
    ///
    /// - parameters:
    ///     - gamepad: The `ExtendedGamepad` that had a value change.
    ///     - button: The `ExtendedGamepad.ButtonElement` that has changed.
    ///     - value: The amount of pressure being applied to the `button` when the callback is triggered. It ranges from `0.0` (minimum pressure) and `1.0` (maximum pressure).
    ///     - pressed: A `Bool` value that indicates if the `button` is considered pressed when the callback is triggered.
    public typealias OnButtonChangeCallback = (_ gamepad: ExtendedGamepad, _ button: ButtonElement, _ value: Float, _  pressed: Bool) -> Void
    
    public typealias OnDirectionalPadChangeCallback = (_ gamepad: ExtendedGamepad, _ directionalPad: DirectionalPadElement, _ xValue: Float, _  yValue: Float) -> Void
    
    /// A `CallbackIdentifier` is given when adding a new callback. It can be used to remove the callback.
    public typealias CallbackIdentifier = UUID
    
    /// Any Element that can be part of an `ExtendedGamepad`. It is enclosed within this enum in order to use this as the generic return/input type.
    ///
    /// - button: Any `ExtendedGamepad.ButtonElement`.
    /// - directionalPad: Any `ExtendedGamepad.DirectionalPadElement`.
    public enum Element: GamepadElementProtocol {
        /// Any `ExtendedGamepad.ButtonElement`.
        case button(ButtonElement)
        
        /// Any `ExtendedGamepad.DirectionalPadElement`.
        case directionalPad(DirectionalPadElement)
        
        public func gcElement(gamepad: GCExtendedGamepad) ->  GCControllerElement {
            switch self {
            case .button(let button):
                return button.gcElement(gamepad: gamepad)
            case .directionalPad(let directionalPad):
                return directionalPad.gcElement(gamepad: gamepad)
            }
        }
        
        var element: Element {
            return self
        }
    }
    
    /// A button on an `ExtendedGamepad`. These can be pressed and have a pressure ranging from `0.0` (minimum) to `1.0` (maximum).
    ///
    /// - buttonA: The **A** button on a controller
    /// - buttonB: The **B** button on a controller
    /// - buttonX: The **X** button on a controller
    /// - buttonY: The **Y** button on a controller
    /// - L1: The **L1** bumper on a controller
    /// - L2: The **L2** trigger on a controller
    /// - R1: The **R1** bumper on a controller
    /// - R2: The **R2** trigger on a controller
    /// - dPadUp: The **Up** button on a D-Pad
    /// - dPadDown: The **Down** button on a D-Pad
    /// - dPadLeft: The **Left** button on a D-Pad
    /// - dPadRight: The **Right** button on a D-Pad
    /// - leftJoystickUp: The **Up** component of the **Left Joystick** on a controller
    /// - leftJoystickDown: The **Down** component of the **Left Joystick** on a controller
    /// - leftJoystickLeft: The **Left** component of the **Left Joystick** on a controller
    /// - leftJoystickRight: The **Right** component of the **Left Joystick** on a controller
    /// - rightJoystickUp: he **Up** component of the **Right Joystick** on a controller
    /// - rightJoystickDown: The **Down** component of the **Right Joystick** on a controller
    /// - rightJoystickLeft: The **Left** component of the **Right Joystick** on a controller
    /// - rightJoystickRight: The **Right** component of the **Right Joystick** on a controller
    public enum ButtonElement: ExtendedGamepadElementProtocol {
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
        
        public var element: Element {
            return .button(self)
        }
    }
    
    /// A directional pad of an `ExtendedGamepad`. These elements represent anything with 4 axis of directional movement.
    ///
    /// - dPad: The **D-Pad** on a controller
    /// - leftJoystick: The **Left Joystick** on a controller
    /// - rightJoystick: The **Right Joystick** on a controller
    public enum DirectionalPadElement: ExtendedGamepadElementProtocol {
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
        
        public var element: Element {
            return .directionalPad(self)
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
    
    /// Used to protect `var onButtonChangeCallbacks`.
    private let onButtonChangeCallbacksLock = NSLock()
    
    /// This dictionary is used to keep track of callbacks for On Change events of Buttons in such a way that they can be removed if desired.
    private var onButtonChangeCallbacks: [CallbackIdentifier: OnButtonChangeCallback] = [:]
    
    /// Used to protect `var onDirectionalPadChangeCallbacks`.
    private let onDirectionalPadChangeCallbackLock = NSLock()
    
    /// This dictionary is used to keep track of callbacks for On Change events of Direcitonal Pads in such a way that they can be removed if desired.
    private var onDirectionalPadChangeCallbacks: [CallbackIdentifier: OnDirectionalPadChangeCallback] = [:]
    
    /// Used to bridge GCControlerElement's to the element type quickly.
    private var elementMap: [HashableWeakVar<GCControllerElement>: ExtendedGamepad.Element] = [:]
    
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
        elementMap[gamepad.buttonA] = ButtonElement.buttonA.element
        elementMap[gamepad.buttonB] = ButtonElement.buttonB.element
        elementMap[gamepad.buttonX] = ButtonElement.buttonX.element
        elementMap[gamepad.buttonY] = ButtonElement.buttonY.element
        
        elementMap[gamepad.leftShoulder] = ButtonElement.L1.element
        elementMap[gamepad.leftTrigger] = ButtonElement.L2.element
        elementMap[gamepad.rightShoulder] = ButtonElement.R1.element
        elementMap[gamepad.rightTrigger] = ButtonElement.R2.element
        
        elementMap[gamepad.dpad.up] = ButtonElement.dPadUp.element
        elementMap[gamepad.dpad.down] = ButtonElement.dPadDown.element
        elementMap[gamepad.dpad.left] = ButtonElement.dPadLeft.element
        elementMap[gamepad.dpad.right] = ButtonElement.dPadRight.element
        
        elementMap[gamepad.leftThumbstick.up] = ButtonElement.leftJoystickUp.element
        elementMap[gamepad.leftThumbstick.down] = ButtonElement.leftJoystickDown.element
        elementMap[gamepad.leftThumbstick.left] = ButtonElement.leftJoystickLeft.element
        elementMap[gamepad.leftThumbstick.right] = ButtonElement.leftJoystickRight.element
        
        elementMap[gamepad.rightThumbstick.up] = ButtonElement.rightJoystickUp.element
        elementMap[gamepad.rightThumbstick.down] = ButtonElement.rightJoystickDown.element
        elementMap[gamepad.rightThumbstick.left] = ButtonElement.rightJoystickLeft.element
        elementMap[gamepad.rightThumbstick.right] = ButtonElement.rightJoystickRight.element
        
        elementMap[gamepad.dpad] = DirectionalPadElement.dPad.element
        elementMap[gamepad.leftThumbstick] = DirectionalPadElement.leftJoystick.element
        elementMap[gamepad.rightThumbstick] = DirectionalPadElement.rightJoystick.element
    }
    
    //MARK:- Funcs
    public func onChange(callback: @escaping ValueChangeCallback) -> CallbackIdentifier {
        return valueChangedCallbacksLock.valuedExecute {
            let callbackID = CallbackIdentifier()
            
            if self.valueChangedCallbacks.isEmpty {
                self.extendedGamepad.valueChangedHandler = onChangeHandler
            }
            
            self.valueChangedCallbacks[callbackID] = callback
            return callbackID
        }
    }
    
    private func onChangeHandler(gamepad: GCExtendedGamepad, gcElement: GCControllerElement) {
        let callbacks = valueChangedCallbacksLock.valuedExecute { self.valueChangedCallbacks }
        
        guard let element = elementMap[gcElement] ?? gcElement.elementTypeFrom(gamepad: self.extendedGamepad) else {
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
        
        return onButtonChangeCallbacksLock.valuedExecute {
            let callbackId = CallbackIdentifier()
            
            if self.onButtonChangeCallbacks.isEmpty {
                gcButton.valueChangedHandler = onChangeButtonHandler
            }
            
            self.onButtonChangeCallbacks[callbackId] = callback
            return callbackId
        }
    }
    
    private func onChangeButtonHandler(gcButton: GCControllerButtonInput, value: Float, pressed: Bool) {
        let callbacks = onButtonChangeCallbacksLock.valuedExecute { self.onButtonChangeCallbacks }
        
        guard let element = (elementMap[gcButton] ?? gcButton.elementTypeFrom(gamepad: extendedGamepad)) else {
            fatalError("Unable to convert gcElement into ButtonElement")
        }
        
        if case .button(let element) = element {
            for callback in callbacks.values {
                callback(self, element, value, pressed)
            }
        }
    }
    
    public func onChange(directionalPad: DirectionalPadElement, callback: @escaping OnDirectionalPadChangeCallback) -> CallbackIdentifier {
        guard let gcDicrectionalPad = directionalPad.gcElement(gamepad: extendedGamepad) as? GCControllerDirectionPad  else {
            fatalError()
        }
        return onDirectionalPadChangeCallbackLock.valuedExecute {
            let callbackId = CallbackIdentifier()
            
            if self.onDirectionalPadChangeCallbacks.isEmpty {
                gcDicrectionalPad.valueChangedHandler = onChangeDirectionalPadHandler
            }
            
            self.onDirectionalPadChangeCallbacks[callbackId] = callback
            return callbackId
        }
    }
    
    private func onChangeDirectionalPadHandler(gcDirectionalPad: GCControllerDirectionPad, xValue: Float, yValue: Float) {
        let callbacks = onDirectionalPadChangeCallbackLock.valuedExecute { self.onDirectionalPadChangeCallbacks }
        
        guard let element = (elementMap[gcDirectionalPad] ?? gcDirectionalPad.elementTypeFrom(gamepad: extendedGamepad)) else {
            fatalError()
        }
        
        if case .directionalPad(let directionalPad) = element {
            for callback in callbacks.values {
                callback(self, directionalPad, xValue, yValue)
            }
        }
    }
}

fileprivate extension GCControllerElement {
    func elementTypeFrom(gamepad: GCExtendedGamepad) -> ExtendedGamepad.Element? {
        return { Void -> ExtendedGamepadElementProtocol? in
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
        }()?.element
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




