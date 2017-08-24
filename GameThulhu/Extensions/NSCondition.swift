//
//  NSCondition.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

public extension NSCondition {
    func waitWhile( _ closure: () -> Bool) {
        self.lock()
        while (closure()) {
            self.wait()
        }
        self.unlock()
    }
    
    func broadcastEvent(_ closure: () -> Void) {
        self.lock()
        closure()
        self.broadcast()
        self.unlock()
    }
    
    func signalEvent(_ closure: () -> Void) {
        self.lock()
        closure()
        self.signal()
        self.unlock()
    }
}
