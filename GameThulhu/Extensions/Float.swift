//
//  Float.swift
//  GameThulhu
//
//  Created by Braden Scothern on 7/24/17.
//  Copyright © 2017 DanceToaster LLC. All rights reserved.
//

import Foundation

extension Float {
    func format(_ f: String) -> String {
        return NSString(format: f as NSString, self) as String
    }
}
