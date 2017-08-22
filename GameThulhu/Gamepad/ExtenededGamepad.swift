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
    
    public enum Action {
        case pressed
        case changed
    }
    
    public enum Element: Hashable {
        case button(button: ButtonElement)
        case dpad(dpad: DirectionalPadElement)
        
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
    
    public enum ButtonElement: Hashable {
        public enum Direction {
            case up
            case down
            case left
            case right
            
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
        case buttonA
        case buttonB
        case buttonX
        case buttonY
        
        case L1
        case L2
        case R1
        case R2
        
        case dPad(direction: Direction)
        case leftJoystick(direction: Direction)
        case rightJoystick(direction: Direction)
        
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
        
        fileprivate var element: Element {
            return Element.button(button: self)
        }
    }
    
    public enum DirectionalPadElement {
        case dPad
        case leftJoystick
        case rightJoystick
        
        fileprivate var element: Element {
            return Element.dpad(dpad: self)
        }
    }
    
    //MARK:- Properties
    //MARK: Private
    
    /// Used to access the GCExtendedGamepad for this object.
    private var extendedGamepad: GCExtendedGamepad {
        return controller.extendedGamepad!
    }
    
    private let buttonActionMapLock = NSRecursiveLock()
    private var buttonActionMap: [ButtonElement: Action] = [:]
    
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
    
    @inline(__always) private func configureHandlers(button: ButtonElement, gcButton: GCControllerButtonInput, callback: ExtendedGamepadDelegate.ButtonCallback?) {
        switch buttonActionMap[button]! {
        case .changed:
            gcButton.pressedChangedHandler = nil
            gcButton.valueChangedHandler = (callback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
                guard let _self = self else {
                    button.valueChangedHandler = nil
                    return
                }
                callback?(_self, value, pressed)
            }
            
        case .pressed:
            gcButton.valueChangedHandler = nil
            gcButton.pressedChangedHandler = (callback == nil) ? nil:{ [weak self](button: GCControllerButtonInput, value: Float, pressed: Bool) -> Void in
                guard let _self = self else {
                    button.pressedChangedHandler = nil
                    return
                }
                callback?(_self, value, pressed)
            }
        }
    }
    
    @inline(__always) private func configureHandlers(gcDPad: GCControllerDirectionPad, callback: ExtendedGamepadDelegate.DirectionalPadCallback?) {
        gcDPad.valueChangedHandler = (callback == nil) ? nil:{ [weak self](dpad: GCControllerDirectionPad, xValue: Float, yValue: Float) -> Void in
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
    public func set(button: ButtonElement, action: Action) {
        buttonActionMapLock.execute {
            buttonActionMap[button] = action
            configureHandlers(button: button, gcButton: extendedGamepad.get(button: button), callback: extendedGamepadDelegate?.get(button: button))
        }
    }
}

fileprivate extension GCExtendedGamepad {
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
