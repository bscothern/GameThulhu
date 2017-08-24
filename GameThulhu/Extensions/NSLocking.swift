//
//  NSLocking.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

extension NSLocking {
    fileprivate var memoryAddress: Int {
        // The dropFirst(2) is needed in order to remove the 0x at the start of the pointer value
        return Int(String("\(Unmanaged.passUnretained(self).toOpaque())".characters.dropFirst(2)), radix: 16)!
    }
    
    @inline(__always) func execute(_ closure: () -> Void) {
        let _ = valuedExecute(closure)
    }
    
    @inline(__always) func valuedExecute<T>(_ closure: () -> T) -> T {
        do {
            self.lock()
            defer {
                self.unlock()
            }
            return closure()
        }
    }
}

extension NSLocking where Self: Hashable {
    fileprivate static func sort(locks: Set<Self>) -> [Self] {
        return locks.sorted { (lock1: Self, lock2: Self) -> Bool in
            return lock1.memoryAddress > lock2.memoryAddress
        }
    }
    
    @inline(__always) static func multiLockExecute(locks: Set<Self>, _ closure: () -> Void) {
        let _ = multiLockValuedExecute(locks: locks, closure)
    }
    
    static func multiLockValuedExecute<T>(locks: Set<Self>, _ closure: () -> T) -> T {
        let sortedLocks = Self.sort(locks: locks)
        
        for lock in sortedLocks {
            lock.lock()
        }
        defer {
            for lock in sortedLocks.reversed() {
                lock.unlock()
            }
        }
        return closure()
    }
}

extension NSLocking where Self: ConveniencedLock {
    @inline(__always) func tryExecute(_ closure: () -> Void) -> Bool {
        return tryValuedExecute(closure).0
    }
    
    func tryValuedExecute<T>(_ closure: () -> T) -> (Bool, T?) {
        guard self.try() else {
            return (false, nil)
        }
        defer {
            self.unlock()
        }
        return (true , closure())
    }
    
    @inline(__always) static func tryMultiLockExecute(locks: Set<Self>, _ closure: () -> Void) -> Bool {
        return tryMultiLockValuedExecute(locks: locks, closure).0
    }
    
    static func tryMultiLockValuedExecute<T>(locks: Set<Self>, _ closure: () -> T) -> (Bool, T?) {
        let sortedLocks = Self.sort(locks: locks)
        var locked: [Self] = []
        
        for lock in sortedLocks {
            guard lock.try() else {
                for lock in locked {
                    lock.unlock()
                }
                return (false, nil)
            }
            locked.append(lock)
        }
        defer {
            for lock in sortedLocks.reversed() {
                lock.unlock()
            }
        }
        
        return (true, closure())
    }
}
