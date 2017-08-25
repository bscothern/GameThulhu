//
//  ButtonCallbackType.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

/// The callback actions that can take place on a `Button`.
///
/// - began: Reresents `EventResponder.gamepadButtonPressBegan()`.
/// - changed: Represents `EventResponder.gamepadButtonPressChanged()`.
/// - ended: Represents `EventResponder.gamepadButtonPressEnded()`.
@objc enum ButtonCallbackType: Int {
    
    /// Reresents `EventResponder.gamepadButtonPressBegan()`.
    case began
    
    /// Represents `EventResponder.gamepadButtonPressChanged()`.
    case changed
    
    /// Represents `EventResponder.gamepadButtonPressEnded()`.
    case ended
}
