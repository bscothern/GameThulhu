//
//  ConvenienceLock.swift
//  GameThulhu
//
//  Created by Braden Scothern on 8/23/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

protocol ConveniencedLock: NSLocking, Hashable {
    init()
    var name: String? { get set }
    func `try`() -> Bool
}

extension ConveniencedLock {
    init(name: String) {
        self.init()
        self.name = name
    }
    
    @inline(__always) func assertLocked(file: StaticString = #file, line: UInt = #line) {
        assert(!self.try(), "You must lock \(name ?? "") to continue", file: file, line: line)
    }
    
    @inline(__always) func assertUnlocked(file: StaticString = #file, line: UInt = #line) {
        assert(self.try(), "You must unlock \(name ?? "") to continue", file: file, line: line)
    }
}
