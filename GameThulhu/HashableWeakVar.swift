//
//  HashableWeakVar.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

/// A wrapper around a `Hashable` object that can be used to keep a weak reference to the class inside of a collection.
internal struct HashableWeakVar<T>: Hashable where T: AnyObject, T: Hashable {
    public typealias ContainedType = T
    
    weak var value: T?
    
    init(_ value: T) {
        self.value = value
    }
    
    //MARK:- Protocol Implementatin
    //MARK: Equatable
    internal static func ==<T>(lhs: HashableWeakVar<T>, rhs: HashableWeakVar<T>) -> Bool {
        return lhs.value == rhs.value
    }
    
    //MARK: Hashable
    var hashValue: Int {
        return value?.hashValue ?? 0
    }
}
