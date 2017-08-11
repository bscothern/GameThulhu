//
//  Float.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

internal extension Float {
    func format(_ f: String) -> String {
        return NSString(format: f as NSString, self) as String
    }
    
    func clamped(to range: ClosedRange<Float>) -> Float {
        return self < range.lowerBound ? range.lowerBound:(self > range.upperBound ? range.upperBound:self)
    }
    
    mutating func clamp(to range: ClosedRange<Float>) {
        self = self.clamped(to: range)
    }
}
