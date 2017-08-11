//
//  Float.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
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
