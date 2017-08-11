//
//  NSLocking.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

internal extension NSLocking {
    /// This function will safely lock the `NSLocking` instance, execute the given closure, and then unlock before returning.
    ///
    /// - parameter closure: A closure to execute while the `NSLocking` instance is locked.
    @inline(__always) func execute(_ closure: () -> Void) {
        valuedExecute(closure)
    }
    
    /// This function will safely lock the `NSLocking` instance, execute the given closure, and then unlock before returning.
    ///
    /// - parameter closure: A closure to execute while the `NSLocking` instance is locked that return some value.
    func valuedExecute<T>(_ closure: () -> T) -> T {
        do {
            self.lock()
            defer {
                self.unlock()
            }
            return closure()
        }
    }
}
