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
    //MARK: Private
    enum PrivateError: Error {
        case invaidElement
        case elementNotFound
    }
    
    private typealias WrappedButtonCallback = (id: CallbackIdentifier, callback: OnButtonChangeCallback)
    private typealias WrappedDirectionalPadCallback = (id: CallbackIdentifier, callback: OnDirectionalPadChangeCallback)
    
    //MARK: Public
    
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
    ///     - gamepad: The `ExtendedGamepad` that had a value change.
    ///     - directionalPad: The `DirectonalPadElement` that has changed.
    ///     - xValue: The value of the directional pad along the x-axis. This ranges from `-1.0` (maximum left) to `1.0` (maximum right).
    ///     - yValue: The value of the directional pad along the y-axis. This ranges from `-1.0` (maximum down) to `1.0` (maximum up).
    public typealias OnDirectionalPadChangeCallback = (_ gamepad: ExtendedGamepad, _ directionalPad: DirectionalPadElement, _ xValue: Float, _  yValue: Float) -> Void
    
    /// A `CallbackIdentifier` is given/returned when adding a callback to any `ExtendedGamepad.Element`. Multiple callbacks can use the same `CallbackIdentifier` if you wish to unregister them.
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
    /// - dPad: The **D-Pad** on a controller along with the `Direction` that is desired on it.
    /// - leftJoystick: The **Left Joystick** on a controller along with the `Direction` that is desired on it.
    /// - rightJoystick: The **Right Joystick** on a controller along with the `Direction` that is desired on it.
    public enum ButtonElement: ExtendedGamepadElementProtocol, Hashable {
        
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
        
        /// The **D-Pad** on a controller along with the `Direction` that is desired on it.
        case dPad(Direction)
        
        /// The **Left Joystick** on a controller along with the `Direction` that is desired on it.
        case leftJoystick(Direction)
        
        /// The **Right Joystick** on a controller along with the `Direction` that is desired on it.
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
        
        /// The `ExtendedGampepad.ButtonElement.Direction` that this the `ExtendedGamepad.ButtonElement` is refering to if applicable.
        /// If the `ExtendedGamepad.ButtonElement` is not a directional pad type, then `nil` is returned instead.
        var direction: Direction? {
            switch self {
            case .dPad(let direction), .leftJoystick(let direction), .rightJoystick(let direction):
                return direction
            default:
                return nil
            }
        }
        
        //MARK:- Protocol Conformance
        
        //MARK: Equatable
        public static func ==(lhs: ExtendedGamepad.ButtonElement, rhs: ExtendedGamepad.ButtonElement) -> Bool {
            // While this is usually VERY BAD to do, it is ok in this case because we know that all the hashValues are unique, consistent, and that this will be fast.
            return lhs.hashValue == rhs.hashValue
        }
        
        //MARK: Hashable
        public var hashValue: Int {
            switch self {
            case .buttonA:
                return 0
            case .buttonB:
                return 1
            case .buttonX:
                return 2
            case .buttonY:
                return 3
            case .L1:
                return 4
            case .L2:
                return 5
            case .R1:
                return 6
            case .R2:
                return 7
            case .dPad(let direction):
                switch direction {
                case .up:
                    return 8
                case .down:
                    return 9
                case .left:
                    return 10
                case .right:
                    return 11
                }
            case .leftJoystick(let direction):
                switch direction {
                case .up:
                    return 12
                case .down:
                    return 13
                case .left:
                    return 14
                case .right:
                    return 15
                }
            case .rightJoystick(let direction):
                switch direction {
                case .up:
                    return 16
                case .down:
                    return 17
                case .left:
                    return 18
                case .right:
                    return 19
                }
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
    private var valueChangedCallbacks: [CallbackIdentifier: [ValueChangeCallback]] = [:]
    
    /// Used to protect `var onButtonChangeCallbacks`.
    private let onButtonChangeCallbacksLock = NSLock()
    
    /// This dictionary is used to keep track of callbacks for On Change events of Buttons in such a way that they can be removed if desired.
    private var onButtonChangeCallbacks: [ButtonElement: [WrappedButtonCallback]] = [:]
    
    /// Used to protect `var onDirectionalPadChangeCallbacks`.
    private let onDirectionalPadChangeCallbackLock = NSLock()
    
    /// This dictionary is used to keep track of callbacks for On Change events of Direcitonal Pads in such a way that they can be removed if desired.
    private var onDirectionalPadChangeCallbacks: [DirectionalPadElement: [WrappedDirectionalPadCallback]] = [:]
    
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
    //MARK: Private
    
    /// The callback for `GCExtendedGamepad.valueChangedHandler`.
    ///
    /// - Parameters:
    ///   - gamepad: The `GCExtnededGamepad` which has changed.
    ///   - gcElement: The `GCControllerElement` that has changed on the `gamepad`.
    private func onChangeHandler(gamepad: GCExtendedGamepad, gcElement: GCControllerElement) {
        guard let element = elementMap[gcElement] ?? gcElement.elementTypeFrom(gamepad: self.extendedGamepad) else {
            return
        }
        
        let callbacksCopy = valueChangedCallbacksLock.valuedExecute { self.valueChangedCallbacks }
        for callbacks in callbacksCopy.values {
            for callback in callbacks {
                callback(self, element)
            }
        }
    }
    
    /// Create an efficient callback for the given gcButton.
    ///
    /// - Parameter gcButton: The button that will be watched with this callback.
    /// - Throws: `PrivateError.elementNotFound` is thrown when the element cannot be found and `PrivateError.inalidElement` is thrown if the elemet is not a `ExtednedGamepad.Element.button` in the mapping
    private func createOnChangeButtonHandler(gcButton: GCControllerButtonInput) throws -> ((_ gcButton: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void) {
        guard let element = (elementMap[gcButton] ?? gcButton.elementTypeFrom(gamepad: extendedGamepad)) else {
            throw PrivateError.elementNotFound
        }
        if case .button(let button) = element {
            return { [weak self](gcButton: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
                guard let _self = self,
                    let callbacks = _self.onButtonChangeCallbacksLock.valuedExecute({ _self.onButtonChangeCallbacks[button] })
                    else {
                        return
                }

                for callback in callbacks {
                    callback.callback(_self, button, value, pressed)
                }
            }
        }
        throw PrivateError.invaidElement
    }
    
    private func createOnChangeDirectionalPadHandler(gcDirectionalPad: GCControllerDirectionPad) throws -> ((_ gcDirectionalPad: GCControllerDirectionPad, _ xValue: Float, _ yValue: Float) -> Void) {
        guard let element = (elementMap[gcDirectionalPad] ?? gcDirectionalPad.elementTypeFrom(gamepad: extendedGamepad)) else {
            throw PrivateError.elementNotFound
        }
        if case .directionalPad(let directionalPad) = element {
            return { [weak self](gcDirectionalPad: GCControllerDirectionPad, xValue: Float, yValue: Float) -> Void in
                guard let _self = self,
                    let callbacks = _self.onDirectionalPadChangeCallbackLock.valuedExecute({ _self.onDirectionalPadChangeCallbacks[directionalPad] })
                    else {
                        return
                }
                
                for callback in callbacks {
                    callback.callback(_self, directionalPad, xValue, yValue)
                }
            }
        }
        throw PrivateError.invaidElement
    }
    
    //MARK: Public
    
    @discardableResult public func onChange(callbackIdentifier: CallbackIdentifier = CallbackIdentifier(), callback: @escaping ValueChangeCallback) -> CallbackIdentifier {
        valueChangedCallbacksLock.execute {
            if self.valueChangedCallbacks.isEmpty {
                self.extendedGamepad.valueChangedHandler = onChangeHandler
            }
            if self.valueChangedCallbacks[callbackIdentifier] == nil {
                self.valueChangedCallbacks[callbackIdentifier] = []
            }
            self.valueChangedCallbacks[callbackIdentifier]!.append(callback)
        }
        return callbackIdentifier
    }
    
    public func unregisterValueChangedCallback(callbackIdentifier: CallbackIdentifier) {
        valueChangedCallbacksLock.execute {
            self.valueChangedCallbacks.removeValue(forKey: callbackIdentifier)
        }
    }
    
    @discardableResult public func onChange(button: ButtonElement, callbackIdentifier: CallbackIdentifier = CallbackIdentifier(), callback: @escaping OnButtonChangeCallback) -> CallbackIdentifier {
        guard let gcButton = button.gcElement(gamepad: extendedGamepad) as? GCControllerButtonInput else {
            fatalError()
        }
        
        onButtonChangeCallbacksLock.execute {
            if self.onButtonChangeCallbacks.isEmpty {
                do {
                    gcButton.valueChangedHandler = try createOnChangeButtonHandler(gcButton: gcButton)
                } catch {
                    print("createOnChangeButtonHandler Failure: \(error)")
                    return
                }
                
                self.onButtonChangeCallbacks[button] = []
            }
            
            self.onButtonChangeCallbacks[button]!.append((callbackIdentifier, callback))
        }
        return callbackIdentifier
    }
    
    public func unregisterButtonCallback(button: ButtonElement, callbackIdentifier: CallbackIdentifier) {
        onButtonChangeCallbacksLock.execute {
            guard let array: [ExtendedGamepad.WrappedButtonCallback] = self.onButtonChangeCallbacks[button] else {
                return
            }
            self.onButtonChangeCallbacks[button] = array.flatMap { (callback: WrappedButtonCallback) in
                guard callback.id != callbackIdentifier else {
                    return nil
                }
                return callback
            }
        }
    }
    
    @discardableResult public func onChange(directionalPad: DirectionalPadElement, callbackIdentifier: CallbackIdentifier = CallbackIdentifier(), callback: @escaping OnDirectionalPadChangeCallback) -> CallbackIdentifier {
        guard let gcDicrectionalPad = directionalPad.gcElement(gamepad: extendedGamepad) as? GCControllerDirectionPad  else {
            fatalError()
        }
        onDirectionalPadChangeCallbackLock.execute {
            if self.onDirectionalPadChangeCallbacks.isEmpty {
                do {
                    gcDicrectionalPad.valueChangedHandler = try createOnChangeDirectionalPadHandler(gcDirectionalPad: gcDicrectionalPad)
                } catch {
                    print("createOnChangeDirectionalPadHandler Failure: \(error)")
                    return
                }
                
                self.onDirectionalPadChangeCallbacks[directionalPad] = []
            }
            
            self.onDirectionalPadChangeCallbacks[directionalPad]!.append((callbackIdentifier, callback))
        }
        return callbackIdentifier
    }
    
    public func unregisterDirectionalPadCallback(directionalPad: DirectionalPadElement, callbackIdentifier: CallbackIdentifier) {
        onDirectionalPadChangeCallbackLock.execute {
            guard let array = self.onDirectionalPadChangeCallbacks[directionalPad] else {
                return
            }
            self.onDirectionalPadChangeCallbacks[directionalPad] = array.flatMap { (callback: WrappedDirectionalPadCallback) in
                guard callback.id != callbackIdentifier else {
                    return nil
                }
                return callback
            }
        }
    }
}

fileprivate extension GCControllerElement {
    /// Bridge a `GCControllerElement` to the correct `ExtendedGamepad.Element` by inspecing the given `gamepad`.
    ///
    /// - Parameter gamepad: The `gamepad` which should be inspected for this `GCControllerElement`.
    /// - Returns: The `ExtendedGampepad.Element` that cooresponds to the `self` if it is part of the `gamepad`, `nil` otherwise.
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
    /// Allows the use of a `GCControllerElement` as the key rather than needing to wrap it in a `HashableWeakVar`.
    ///
    /// - Parameter rawKey: The `GCControllerElement` with a cooresponding element that is desired.
    subscript(rawKey: GCControllerElement) -> Dictionary.Value? {
        get {
            return self[HashableWeakVar(rawKey)]
        }
        mutating set {
            self[HashableWeakVar(rawKey)] = newValue
        }
    }
}




