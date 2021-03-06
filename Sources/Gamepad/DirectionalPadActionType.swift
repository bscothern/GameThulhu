//
//  DirectionalPadActionType.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/24/17.
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

/// The modes that a directional pad can be in and act upon. A directional pad can be considered a single `DirectionalPad` or 4 individual `Button` elements.
///
/// - dPad: A single `DirectionalPad` representation is desired.
/// - buttons: 4 `Button` elements representation is desired.
@objc public enum DirectionalPadActionType: Int {

    /// A single `DirectionalPad` representation is desired.
    case dPad

    /// 4 `Button` elements representation is desired.
    case buttons
}
