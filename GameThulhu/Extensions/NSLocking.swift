//
//  NSLocking.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

internal extension NSLocking {
    @inline(__always) func execute(_ closure: () -> Void) {
        valuedExecute(closure)
    }
    
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
