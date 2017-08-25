//
//  DirectionalPadActionType.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

/// The modes that a directional pad can be in and act upon. A directional pad can be considered a single `DirectionalPad` or 4 individual `Button` elements.
///
/// - dPad: A single `DirectionalPad` representation is desired.
/// - buttons: 4 `Button` elements representation is desired.
public enum DirectionalPadActionType {
    
    /// A single `DirectionalPad` representation is desired.
    case dPad
    
    /// 4 `Button` elements representation is desired.
    case buttons
}
