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
    
    /// A function that will be called when a value changes on any `ExtendedGamepad.DirectionalPadElement`.
    ///
    /// - parameters:
    ///     - gamepad:
    ///     - directionalPad:
    ///     - xValue:
    ///     - yValue:
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
        
        /// The directions that a directional pad `ExtendedGamepad.ButtonElement` can be pushed when it is being considered as a button. This applies to the following `ExtendedGamepad.ButtonElement` values:
        /// * `.dPad`
        /// * `.leftJoystick`
        /// * `.rightJoystick`
        ///
        /// The valid directions are:
        ///
        /// - up: The **Up** button of the directional pad `ButtonElement`
        /// - down: The **Dowm** button of the directional pad `ButtonElement`
        /// - left: The **Left** button of the directional pad `ButtonElement`
        /// - right: The **Right** button of the directional pad `ButtonElement`
        public enum Direction {
            
            /// The **Up** button of the directional pad `ButtonElement`
            case up
            
            /// The **Dowm** button of the directional pad `ButtonElement`
            case down
            
            /// The **Left** button of the directional pad `ButtonElement`
            case left
            
            /// The **Right** button of the directional pad  `ButtonElement`
            case right
        }
        
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
        case dPad(Direction)
        
        /// The **Left Joystick** on a controller and the `Direction` that is desired on it.
        case leftJoystick(Direction)
        
        /// The **Up** component of the **Right Joystick** on a controller
        case rightJoystick(Direction)
        
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

            case .dPad(let direction):
                switch direction {
                case .up:
                    return gamepad.dpad.up
                case .down:
                    return gamepad.dpad.down
                case .left:
                    return gamepad.dpad.left
                case .right:
                    return gamepad.dpad.right
                }

            case .leftJoystick(let direction):
                switch direction {
                case .up:
                    return gamepad.leftThumbstick.up
                case .down:
                    return gamepad.leftThumbstick.down
                case .left:
                    return gamepad.leftThumbstick.left
                case .right:
                    return gamepad.leftThumbstick.right
                }

            case .rightJoystick(let direction):
                switch direction {
                case .up:
                    return gamepad.rightThumbstick.up
                case .down:
                    return gamepad.rightThumbstick.down
                case .left:
                    return gamepad.rightThumbstick.left
                case .right:
                    return gamepad.rightThumbstick.right
                }
            }
        }
        
        public var element: Element {
            return .button(self)
        }
        
        var direction: Direction? {
            switch self {
            case .dPad(let direction), .leftJoystick(let direction), .rightJoystick(let direction):
                return direction
            default:
                return nil
            }
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
    
    /// Creates an `ExtendedController` if the given `GCController` is an `GCExtendedGamepad`.
    ///
    /// - Parameter controller: The `GCController` which this `ExtendedController` should use. If the property `extendedGampead` returns `nil` this constructor will fail.
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
        
        elementMap[gamepad.dpad.up] = ButtonElement.dPad(.up).element
        elementMap[gamepad.dpad.down] = ButtonElement.dPad(.down).element
        elementMap[gamepad.dpad.left] = ButtonElement.dPad(.left).element
        elementMap[gamepad.dpad.right] = ButtonElement.dPad(.right).element
        
        elementMap[gamepad.leftThumbstick.up] = ButtonElement.leftJoystick(.up).element
        elementMap[gamepad.leftThumbstick.down] = ButtonElement.leftJoystick(.down).element
        elementMap[gamepad.leftThumbstick.left] = ButtonElement.leftJoystick(.left).element
        elementMap[gamepad.leftThumbstick.right] = ButtonElement.leftJoystick(.right).element
        
        elementMap[gamepad.rightThumbstick.up] = ButtonElement.rightJoystick(.up).element
        elementMap[gamepad.rightThumbstick.down] = ButtonElement.rightJoystick(.down).element
        elementMap[gamepad.rightThumbstick.left] = ButtonElement.rightJoystick(.left).element
        elementMap[gamepad.rightThumbstick.right] = ButtonElement.rightJoystick(.right).element
        
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
        switch self {
        case gamepad.buttonA:
            return ExtendedGamepad.ButtonElement.buttonA.element
        case gamepad.buttonB:
            return ExtendedGamepad.ButtonElement.buttonB.element
        case gamepad.buttonX:
            return ExtendedGamepad.ButtonElement.buttonX.element
        case gamepad.buttonY:
            return ExtendedGamepad.ButtonElement.buttonY.element
            
        case gamepad.leftShoulder:
            return ExtendedGamepad.ButtonElement.L1.element
        case gamepad.leftTrigger:
            return ExtendedGamepad.ButtonElement.L2.element
        case gamepad.rightShoulder:
            return ExtendedGamepad.ButtonElement.R1.element
        case gamepad.rightTrigger:
            return ExtendedGamepad.ButtonElement.R2.element
            
        case gamepad.dpad.up:
            return ExtendedGamepad.ButtonElement.dPad(.up).element
        case gamepad.dpad.down:
            return ExtendedGamepad.ButtonElement.dPad(.down).element
        case gamepad.dpad.left:
            return ExtendedGamepad.ButtonElement.dPad(.left).element
        case gamepad.dpad.right:
            return ExtendedGamepad.ButtonElement.dPad(.right).element
            
        case gamepad.leftThumbstick.up:
            return ExtendedGamepad.ButtonElement.leftJoystick(.up).element
        case gamepad.leftThumbstick.down:
            return ExtendedGamepad.ButtonElement.leftJoystick(.down).element
        case gamepad.leftThumbstick.left:
            return ExtendedGamepad.ButtonElement.leftJoystick(.left).element
        case gamepad.leftThumbstick.right:
            return ExtendedGamepad.ButtonElement.leftJoystick(.right).element
            
        case gamepad.rightThumbstick.up:
            return ExtendedGamepad.ButtonElement.rightJoystick(.up).element
        case gamepad.rightThumbstick.down:
            return ExtendedGamepad.ButtonElement.rightJoystick(.down).element
        case gamepad.rightThumbstick.left:
            return ExtendedGamepad.ButtonElement.rightJoystick(.left).element
        case gamepad.rightThumbstick.right:
            return ExtendedGamepad.ButtonElement.rightJoystick(.right).element
            
        case gamepad.dpad:
            return ExtendedGamepad.DirectionalPadElement.dPad.element
        case gamepad.leftThumbstick:
            return ExtendedGamepad.DirectionalPadElement.leftJoystick.element
        case gamepad.rightThumbstick:
            return ExtendedGamepad.DirectionalPadElement.rightJoystick.element
            
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




