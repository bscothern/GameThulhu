//
//  DirectionalPad.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import GameController

/// This struct represents the state of the D-Pad on a game controller device.
@objc public class DirectionalPad: NSObject {

    /// The type of directional pad this is.
    public let type: DirectionalPadType

    /// The **up** button on the D-Pad.
    public let up: Button

    /// The **down** button on the D-Pad.
    public let down: Button

    /// The **left** button on the D-Pad.
    public let left: Button

    /// The **right** button on the D-Pad.
    public let right: Button

    /// Ranging from `-1.0` (left) to `1.0` (right) depending on the value of the X-Axis on the D-Pad.
    public var xAxis: Float {
        return right.value - left.value
    }

    /// Ranging from `-1.0` (down) to `1.0` (up) depending on the value of the Y-Axis on the D-Pad.
    public var yAxis: Float {
        return up.value - down.value
    }

    /// The main constructor for a DPad. A DPad represents the state of the D-Pad on a game controller.
    ///
    /// - Parameters:
    ///   - type: The type of directional pad this is.
    ///   - up: The **up** button on the D-Pad.
    ///   - down: The **down** button on the D-Pad.
    ///   - left: The **left** button on the D-Pad.
    ///   - right: The **right** button on the D-Pad.
    public init(type: DirectionalPadType, up: Button, down: Button, left: Button, right: Button) {
        self.type = type
        self.up = up
        self.down = down
        self.left = left
        self.right = right
    }

    /// A convenient constructor for a DPad. It uses the default Apple representation and converts it.
    ///
    /// - Parameters:
    ///   - type: The type of directional pad this is.
    ///   - dPad: The `GCControllerDirectionPad` that should be converted.
    public convenience init(type: DirectionalPadType, dPad: GCControllerDirectionPad) {
        self.init(type: type, up: Button(type: .dPadUpDirection, button: dPad.up), down: Button(type: .dPadDownDirection, button: dPad.down), left: Button(type: .dPadLeftDirection, button: dPad.left), right: Button(type: .dPadRightDirection, button: dPad.right))
    }

    //MARK:- Protocol Conformance
    //MARK: Equatable
    public static func == (lhs: DirectionalPad, rhs: DirectionalPad) -> Bool {
        return lhs.type == rhs.type &&
            lhs.up == rhs.up &&
            lhs.down == rhs.down &&
            lhs.left == rhs.left &&
            lhs.right == rhs.right
    }

    //MARK: Hashable
    override public var hashValue: Int {
        return ((type.hashValue ^ up.hashValue) << 32) ^ (down.hashValue << 16) ^ (left.hashValue << 8) ^ right.hashValue
    }
}

extension DirectionalPad {
    override public var debugDescription: String {
        return "DirectionalPad -\n\tUp: (\(up.debugDescription)\t\t\tDown: (\(down.debugDescription)\n\tLeft: (\(left.debugDescription)\t\tRight: (\(right.debugDescription)\n\txAxis: \(xAxis.format("%0.2"))\t\tyAxis: \(yAxis.format("%0.2"))"
    }
}
