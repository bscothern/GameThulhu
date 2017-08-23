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
    //MARK:- Types
    //MARK: Public
    
    /// An `Action` is the event callback type supported by `ButtonElement`s. This is used to identify which type of callback event to watch for.
    public enum Action {
        /// When the `value` input of a `ExtendedGamepadDelegate.ButtonCallback` changes.
        case changed
        
        /// When the `pressed` property of the `ExtendedGamepadDelegate.ButtonCallback` changes.
        case pressed
    }
    
    /// A wrapper around `ButtonElement` and `DirectionalPadElement` that is used as a generic type for either.
    public enum Element: Hashable {
        /// Any `ButtonElement`.
        case button(button: ButtonElement)
        
        /// Any `DirectionalPadElement`.
        case dpad(dpad: DirectionalPadElement)
        
        /// Determines if two `Element` values are equal.
        ///
        /// - Parameters:
        ///   - lhs: An `Element` to compare.
        ///   - rhs: Another `Element` to compare.
        /// - Returns: `true` if both `Element` values are pointing to the same type of `Element`, otherwise `false`.
        public static func == (lhs: Element, rhs: Element) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
        public var hashValue: Int {
            switch self {
            case .button(let button):
                return button.hashValue + 1000
            case .dpad(let dpad):
                return dpad.hashValue + 2000
            }
        }
    }
    
    /// The buttons supported on an `ExtendedGamepad`.
    public enum ButtonElement: Hashable {
        /// The directional buttons supported by `DirectionalPadElement`s when considered as a button.
        public enum Direction {
            
            /// The up button of the directional pad.
            case up
            
            /// The down button of the directional pad.
            case down
            
            /// The left button of the directional pad.
            case left
            
            /// The right button of the directional pad.
            case right
            
            /// Helper to `ButtonElement` so it can get a hashValue for the direction and use it to help identify the dpad elements
            fileprivate var hiddenHashValue: Int {
                return {
                    switch self {
                    case .up:
                        return 1
                    case .down:
                        return 2
                    case .left:
                        return 3
                    case .right:
                        return 4
                    }
                }() * 100
            }
        }
        
        /// The **A** button.
        case buttonA
        
        /// The **B** button.
        case buttonB
        
        /// The **X** button.
        case buttonX
        
        /// The **Y** button.
        case buttonY
        
        /// The **Top Left** trigger.
        case L1
        
        /// The **Bottom Left** trigger.
        case L2
        
        /// The **Top Right** trigger.
        case R1
        
        /// The **Bottom Right** trigger.
        case R2
        
        /// The `Direction` of the **D-Pad** to consider as a button.
        case dPad(direction: Direction)
        
        /// The `Direction` of the **Left Joystick** to consider as a button.
        case leftJoystick(direction: Direction)
        
        /// The `Direction` of the **Right Joystick** to consider as a button.
        case rightJoystick(direction: Direction)
        
        /// Determines if two `ButtonElements` have the same value.
        ///
        /// - Parameters:
        ///   - lhs: A `ButtonElement` to compare.
        ///   - rhs: Another `ButtonElement` to compare.
        /// - Returns: `true` if the two `ButtonElement` values are the same, `false` otherwise.
        public static func ==(lhs: ButtonElement, rhs: ButtonElement) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        
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
                return 8 + direction.hiddenHashValue
            case .leftJoystick(let direction):
                return 9 + direction.hiddenHashValue
            case .rightJoystick(let direction):
                return 10 + direction.hiddenHashValue
            }
        }
        
        /// Wrap this `ButtonElement` into an `Element.button`.
        fileprivate var element: Element {
            return Element.button(button: self)
        }
    }
    
    /// The directional pads supported on an `ExtendedGamepad`.
    public enum DirectionalPadElement {
        /// The **D-Pad** on the `ExtendedGamepad`.
        case dPad
        
        /// The **Left Joystick** on the `ExtendedGamepad`.
        case leftJoystick
        
        /// The **Right Joystick** on the `ExtednedGamepad`.
        case rightJoystick
        
        /// Wrap this `DirectionalPadElement` into an `Element.dpad`.
        fileprivate var element: Element {
            return Element.dpad(dpad: self)
        }
    }
    
    /// Use `ButtonProperty` values to have a button watch for a specific property and receive that value along with its callbacks.
    @objc public enum ButtonProperty: Int {
        case pressedDuration
    }
    
    /// The value of a `ButtonProperty` wrapped up so it can be identified and strongly typed.
    @objc public enum ButtonPropertyValue: Int {
        case pressedDuration //(duration: TimeInterval)
    }
    
    //MARK:- Properties
    //MARK: Private
    
    /// Used to access the GCExtendedGamepad for this object.
    private var extendedGamepad: GCExtendedGamepad {
        return controller.extendedGamepad!
    }
    
    /// Used to protect `buttonActionMap`.
    private let buttonActionMapLock = NSRecursiveLock()
    
    /// Used to keep track of the callback type for buttons.
    /// - Note: Protected by `buttonActionMapLock`.
    private var buttonActionMap: [ButtonElement: Action] = [:]
    
    /// Used to protect `buttonPropertyMap`.
    private let buttonPropertyMapLock = NSRecursiveLock()
    
    /// Used to keep track of the properties to observe for buttons.
    /// - Note: Protected by `buttonPropertyMapLock`.
    private var buttonPropertyMap: [ButtonElement: Set<ButtonProperty>] = [:]
    
    //MARK: Public
    
    /// The current view of the ExtendedGamepad's values.
    public var snapshot: ExtendedSnapshot {
        return ExtendedSnapshot(rawSnapshot)
    }
    
    /// The default snapshot object. It is usually wrapped into an `ExtendedSnapshot` to remove the clutter since they are immutable.
    public var rawSnapshot: GCExtendedGamepadSnapshot {
        return extendedGamepad.saveSnapshot()
    }
    
    /// This delegate has all of the callbacks that should be used by the `ExtendedGamepad`.
    /// -Note: You this replaces `Gamepad.gamepadDelegate` with the value assigned.
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
        
        for button: ButtonElement in [ButtonElement.buttonA, ButtonElement.buttonB,
                               ButtonElement.buttonX, ButtonElement.buttonY,
                               ButtonElement.L1, ButtonElement.L2,
                               ButtonElement.R1, ButtonElement.R2,
                               ButtonElement.dPad(direction: .up), ButtonElement.dPad(direction: .down),
                               ButtonElement.dPad(direction: .left), ButtonElement.dPad(direction: .right),
                               ButtonElement.leftJoystick(direction: .up), ButtonElement.leftJoystick(direction: .down),
                               ButtonElement.leftJoystick(direction: .left), ButtonElement.leftJoystick(direction: .right),
                               ButtonElement.rightJoystick(direction: .up), ButtonElement.rightJoystick(direction: .down),
                               ButtonElement.rightJoystick(direction: .left), ButtonElement.rightJoystick(direction: .right)] {
            buttonActionMap[button] = .changed
        }
    }

    //MARK:- Funcs
    //MARK: Private
    
    /// Used to assign `nil` to all callbacks on a button.
    ///
    /// - Parameter button: The `GCControllerButtonInput` which should have its callbacks set to `nil`.
    private func nilifyCalbacks(buttons: [GCControllerButtonInput]) {
        for button in buttons {
            button.valueChangedHandler = nil
        }
    }
    
    /// Used to assign `nil` to all callbacks on a directional pad, including its button elements.
    ///
    /// - Parameter dPad: The `GCControllerDirectionPad` which should have its callbacks set to `nil`.
    private func nilifyCalbacks(dPads: [GCControllerDirectionPad]) {
        for dPad in dPads {
            nilifyCalbacks(buttons: [dPad.up, dPad.down, dPad.left, dPad.right])
            dPad.valueChangedHandler = nil
        }
    }
    
    /// Sets up the callback for the `gcButton` while making sure it only sets it if valid.
    ///
    /// The callback set depends on the value of `buttonActionMap` so for performance reasons you should protect it before calling this function.
    ///
    /// - Parameters:
    ///   - button: The `ButtonElement` that is being modified.
    ///   - gcButton: The actual `GCControllerButtonInput` being modified.
    ///   - callback: The callback function for the `gcButton`.
    @inline(__always) private func configureHandlers(button: ButtonElement, gcButton: GCControllerButtonInput, callback: ExtendedGamepadDelegate.ButtonCallback?) {
        switch buttonActionMap[button]! {
        case .changed:
            gcButton.pressedChangedHandler = nil
            gcButton.valueChangedHandler = (callback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
                guard let _self = self else {
                    button.valueChangedHandler = nil
                    return
                }
                callback?(_self, value, pressed, properties)
            }
            
        case .pressed:
            gcButton.valueChangedHandler = nil
            gcButton.pressedChangedHandler = (callback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
                guard let _self = self else {
                    button.pressedChangedHandler = nil
                    return
                }
                callback?(_self, value, pressed, properties)
            }
        }
    }
    
    /// Sets up the callback for the `gcDPad` while making sure it is valid.
    ///
    /// - Parameters:
    ///   - gcDPad: The `GCControllerDirectionaPad` that is being modified.
    ///   - callback: The callback function for the `gcDPad`.
    @inline(__always) private func configureHandlers(gcDPad: GCControllerDirectionPad, callback: ExtendedGamepadDelegate.DirectionalPadCallback?) {
        gcDPad.valueChangedHandler = (callback == nil) ? nil:{ [weak self](dpad: GCControllerDirectionPad, xValue: Float, yValue: Float) -> Void in
            guard let _self = self else {
                dpad.valueChangedHandler = nil
                return
            }
            callback?(_self, xValue, yValue)
        }
    }
    
    /// Sets up all of the callbacks for the `ExtendedGamepad` with the current delegate values.
    private func configureExtendedGamepadDelegate() {
        //MARK: Verify extendedGamepadDelegate
        guard extendedGamepadDelegate != nil else {
            nilifyCalbacks(buttons: [extendedGamepad.buttonA, extendedGamepad.buttonB, extendedGamepad.buttonX, extendedGamepad.buttonY,
                                     extendedGamepad.leftShoulder, extendedGamepad.leftTrigger, extendedGamepad.rightShoulder, extendedGamepad.rightTrigger])
            nilifyCalbacks(dPads: [extendedGamepad.dpad, extendedGamepad.leftThumbstick, extendedGamepad.rightThumbstick])
            return
        }
        
        buttonActionMapLock.execute {
            //MARK: Configure Button Callbacks
            configureHandlers(button: .buttonA, gcButton: extendedGamepad.buttonA, callback: extendedGamepadDelegate?.buttonA)
            configureHandlers(button: .buttonB, gcButton: extendedGamepad.buttonB, callback: extendedGamepadDelegate?.buttonB)
            configureHandlers(button: .buttonX, gcButton: extendedGamepad.buttonX, callback: extendedGamepadDelegate?.buttonX)
            configureHandlers(button: .buttonY, gcButton: extendedGamepad.buttonY, callback: extendedGamepadDelegate?.buttonY)
            
            //MARK: Configure Trigger Button Callbacks
            configureHandlers(button: .L1, gcButton: extendedGamepad.leftShoulder, callback: extendedGamepadDelegate?.L1)
            configureHandlers(button: .L2, gcButton: extendedGamepad.leftTrigger, callback: extendedGamepadDelegate?.L2)
            configureHandlers(button: .R1, gcButton: extendedGamepad.rightShoulder, callback: extendedGamepadDelegate?.R1)
            configureHandlers(button: .R2, gcButton: extendedGamepad.rightTrigger, callback: extendedGamepadDelegate?.R2)
            
            //MARK: Configure DPad
            configureHandlers(gcDPad: extendedGamepad.dpad, callback: extendedGamepadDelegate?.dPad)
            configureHandlers(button: .dPad(direction: .up), gcButton: extendedGamepad.dpad.up, callback: extendedGamepadDelegate?.dPadUp)
            configureHandlers(button: .dPad(direction: .down), gcButton: extendedGamepad.dpad.down, callback: extendedGamepadDelegate?.dPadDown)
            configureHandlers(button: .dPad(direction: .left), gcButton: extendedGamepad.dpad.left, callback: extendedGamepadDelegate?.dPadLeft)
            configureHandlers(button: .dPad(direction: .right), gcButton: extendedGamepad.dpad.right, callback: extendedGamepadDelegate?.dPadRight)
            
            //MARK: Configure Left Joystick
            configureHandlers(gcDPad: extendedGamepad.leftThumbstick, callback: extendedGamepadDelegate?.leftJoystick)
            configureHandlers(button: .leftJoystick(direction: .up), gcButton: extendedGamepad.leftThumbstick.up, callback: extendedGamepadDelegate?.leftJoystickUp)
            configureHandlers(button: .leftJoystick(direction: .down), gcButton: extendedGamepad.leftThumbstick.down, callback: extendedGamepadDelegate?.leftJoystickDown)
            configureHandlers(button: .leftJoystick(direction: .left), gcButton: extendedGamepad.leftThumbstick.left, callback: extendedGamepadDelegate?.leftJoystickLeft)
            configureHandlers(button: .leftJoystick(direction: .right), gcButton: extendedGamepad.leftThumbstick.right, callback: extendedGamepadDelegate?.leftJoystickRight)
            
            //MARK: Configure Right Joystick
            configureHandlers(gcDPad: extendedGamepad.rightThumbstick, callback: extendedGamepadDelegate?.rightJoystick)
            configureHandlers(button: .rightJoystick(direction: .up), gcButton: extendedGamepad.rightThumbstick.up, callback: extendedGamepadDelegate?.rightJoystickUp)
            configureHandlers(button: .rightJoystick(direction: .down), gcButton: extendedGamepad.rightThumbstick.down, callback: extendedGamepadDelegate?.rightJoystickDown)
            configureHandlers(button: .rightJoystick(direction: .left), gcButton: extendedGamepad.rightThumbstick.left, callback: extendedGamepadDelegate?.rightJoystickLeft)
            configureHandlers(button: .rightJoystick(direction: .right), gcButton: extendedGamepad.rightThumbstick.right, callback: extendedGamepadDelegate?.rightJoystickRight)
        }
    }
    
    //MARK: Public
    /// This is used to cahnge the `Action` that a `button` acts upon for its callback.
    ///
    /// The default value is always `Action.changed`. If you modify it with this it will be persistent across different delegate assignments.
    ///
    /// - Parameters:
    ///   - button: The `ButtonElement` that should have its callback action modified.
    ///   - action: The `Action` that should trigger a callback for the `button`.
    public func set(button: ButtonElement, action: Action) {
        buttonActionMapLock.execute {
            buttonActionMap[button] = action
            configureHandlers(button: button, gcButton: extendedGamepad.get(button: button), callback: extendedGamepadDelegate?.get(button: button))
        }
    }
}

fileprivate extension GCExtendedGamepad {
    /// Bridges a `ExtendedGamepad.ButtonElement` into the correct `GCControllerButtonInput` from the `GCExtendedGamepad`.
    ///
    /// - Parameter button: The `ButtonElement` that is desired from the `GCExtendedGamepad`.
    /// - Returns: The `GCControllerButtonInput` that maps to the given `button`.
    func get(button: ExtendedGamepad.ButtonElement) -> GCControllerButtonInput {
        switch button {
        case .buttonA:
            return buttonA
        case .buttonB:
            return buttonB
        case .buttonX:
            return buttonX
        case .buttonY:
            return buttonY
            
        case .L1:
            return leftShoulder
        case .L2:
            return leftTrigger
        case .R1:
            return rightShoulder
        case .R2:
            return rightTrigger
        
        case .dPad(let direction):
            return dpad.get(direction: direction)
        case .leftJoystick(let direction):
            return leftThumbstick.get(direction: direction)
        case .rightJoystick(let direction):
            return rightThumbstick.get(direction: direction)
        }
    }
}

fileprivate extension GCControllerDirectionPad {
    
    /// Bridge a `ExtendedGamepad.ButtonElement.Direction` from a `GCControllerDirectionalPad` to the `GCControllerButtonInput` of that directional pad.
    ///
    /// - Parameter direction: The direction desired from the `GCControllerDirectionalPad`.
    /// - Returns: THe `GCControllerButtonInput` from the `GCControllerDirectionalPad` thata matches the given `direction`.
    func get(direction: ExtendedGamepad.ButtonElement.Direction) -> GCControllerButtonInput {
        switch direction {
        case .up:
            return up
        case .down:
            return down
        case .left:
            return left
        case .right:
            return right
        }
    }
}

fileprivate extension ExtendedGamepadDelegate {
    
    /// Attempt to get the callback from the `ExtendedGamepadDelegate` for a given `button`.
    ///
    /// - Parameter button: The `ButtonElement` that has the desired callback
    /// - Returns: An `ExtendedGamepadDelegate.ButtonCallback` that matches the given `button` if it is implemented, `nil` otherwise.
    func get(button: ExtendedGamepad.ButtonElement) -> ExtendedGamepadDelegate.ButtonCallback? {
        switch button {
        case .buttonA:
            return buttonA
        case .buttonB:
            return buttonB
        case .buttonX:
            return buttonX
        case .buttonY:
            return buttonY
        
        case .L1:
            return L1
        case .L2:
            return L2
        case .R1:
            return R1
        case .R2:
            return R2
            
        case .dPad(let direction):
            switch direction {
            case .up:
                return dPadUp
            case .down:
                return dPadDown
            case .left:
                return dPadLeft
            case .right:
                return dPadRight
            }
        
        case .leftJoystick(let direction):
            switch direction {
            case .up:
                return leftJoystickUp
            case .down:
                return leftJoystickDown
            case .left:
                return leftJoystickLeft
            case .right:
                return leftJoystickRight
            }
        
        case .rightJoystick(let direction):
                switch direction {
                case .up:
                    return rightJoystickUp
                case .down:
                    return rightJoystickDown
                case .left:
                    return rightJoystickLeft
                case .right:
                    return rightJoystickRight
            }
        }
    }
}
