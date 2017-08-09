//
//  HashableWeakVar.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

public struct HashableWeakVar<T>: Hashable where T: AnyObject, T: Hashable {
    public typealias ContainedType = T
    
    weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
}

//MARK:- Protocol Implementatin
//MARK: Equatable
public func ==<T>(lhs: HashableWeakVar<T>, rhs: HashableWeakVar<T>) -> Bool {
    return lhs.value == rhs.value
}

//MARK: Hashable
public extension HashableWeakVar {
    public var hashValue: Int {
        return value?.hashValue ?? 0
    }
}
