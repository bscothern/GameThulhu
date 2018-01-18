//
//  Float.swift
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

internal extension Float {
    /// Turn the `Float` into a `String` with the given format.
    ///
    /// - Parameter format: The format that this `Float` should take
    /// - Returns: A `String` representation of the `Float` that is formatted to the given `format` value.
    func format(_ format: String) -> String {
        return NSString(format: format as NSString, self) as String
    }

    /// Clamp the `Float` to be within the given range.
    ///
    /// - Parameter range: A `ClosedRange` that has the low and high maximums to clamp to.
    /// - Returns: A `Float` that is within the given `ClosedRange`. If `self` was greater than the `.upperBound` then `.upperBound` is reutrned, if it was less than `.lowerBound` then `.lowerBound` is reutrned, otherwise `self` is returned.
    func clamped(to range: ClosedRange<Float>) -> Float {
        return self < range.lowerBound ? range.lowerBound:(self > range.upperBound ? range.upperBound:self)
    }

    /// Clamp the value of `self` to be within the given range.
    ///
    /// - Parameter range: A `ClosedRange` that has the low and high maximums to clamp `self` to.
    mutating func clamp(to range: ClosedRange<Float>) {
        self = self.clamped(to: range)
    }
}
