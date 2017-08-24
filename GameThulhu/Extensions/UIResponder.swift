//
//  UIResponder.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import UIKit

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    public class var currentFirstResponder: UIResponder? {
        guard UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil) else {
            return nil
        }
        return UIResponder._currentFirstResponder
    }
    
    @objc private func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}


internal extension UIResponder {
    class ButtonWrapper {
        let gamepad: Gamepad
        let button: Button
        let callbackType: ButtonCallbackType
        
        init(gamepad: Gamepad, button: Button, callbackType: ButtonCallbackType) {
            self.gamepad = gamepad
            self.button = button
            self.callbackType = callbackType
        }
    }
    
    class DirectionalPadWrapper {
        let gamepad: Gamepad
        let dPad: DirectionalPad
        let callbackType: DirectionalPadCallbackType
        
        init(gamepad: Gamepad, dPad: DirectionalPad, callbackType: DirectionalPadCallbackType) {
            self.gamepad = gamepad
            self.dPad = dPad
            self.callbackType = callbackType
        }
    }
    
    @inline(__always) static func raiseGamepadEvent(gamepad: Gamepad, button: Button, callbackType: ButtonCallbackType) {
        UIApplication.shared.sendAction(#selector(handleButtonEvent(sender:)), to: nil, from: ButtonWrapper(gamepad: gamepad, button: button, callbackType: callbackType), for: nil)
    }
    
    @inline(__always) static func raiseGamepadEvent(gamepad: Gamepad, dPad: DirectionalPad, callbackType: DirectionalPadCallbackType) {
        UIApplication.shared.sendAction(#selector(handleDirectionalPadEvent(sender:)), to: nil, from: DirectionalPadWrapper(gamepad: gamepad, dPad: dPad, callbackType: callbackType), for: nil)
    }
    
    @objc func handleButtonEvent(sender: AnyObject) {
        let buttonWrapper = (sender as! ButtonWrapper)
        switch buttonWrapper.callbackType {
        case .began:
            gamepadButtonPressBegan(buttonWrapper.gamepad, buttonWrapper.button)
        case .changed:
            gamepadButtonPressChanged(buttonWrapper.gamepad, buttonWrapper.button)
        case .ended:
            gamepadButtonPressEnded(buttonWrapper.gamepad, buttonWrapper.button)
        }
    }
    
    @objc func handleDirectionalPadEvent(sender: AnyObject) {
        let dPadWrapper = (sender as! DirectionalPadWrapper)
        switch dPadWrapper.callbackType {
        case .began:
            gamepadDirectionalPadMovementBegan(dPadWrapper.gamepad, dPadWrapper.dPad)
        case .changed:
            gamepadDirectionalPadChanged(dPadWrapper.gamepad, dPadWrapper.dPad)
        case .ended:
            gamepadDirectionalPadMovementEnded(dPadWrapper.gamepad, dPadWrapper.dPad)
        }
    }
}
