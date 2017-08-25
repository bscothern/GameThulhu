//
//  DirectionalPadCallbackType.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

/// The callback actions that can take place on a `DirectionalPad`.
///
/// - began: Represents `EventResponder.gamepadDirectionalPadMovementBegan()`.
/// - changed: Represents `EventResponder.gamepadDirectionalPadChanged()`.
/// - ended: Represents `EventResponder.gamepadDirectionalPadMovementEnded()`.
enum DirectionalPadCallbackType {
    
    /// Represents `EventResponder.gamepadDirectionalPadMovementBegan()`.
    case began
    
    /// Represents `EventResponder.gamepadDirectionalPadChanged()`.
    case changed
    
    /// Represents `EventResponder.gamepadDirectionalPadMovementEnded()`.
    case ended
}
