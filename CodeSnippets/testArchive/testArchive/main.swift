//
//  main.swift
//  testArchive
//
//  Created by ios on 08.03.17.
//  Copyright © 2017 ios. All rights reserved.
//

import Foundation


print("Hello, World!")

var pink: UInt32 = 0xCC6699

let vData = Data(buffer: UnsafeBufferPointer(start: &pink, count: 1))
let unarchiver = UnSafeKeyedUnarchiver().createUnarchiver(vData)
print ("\(unarchiver)")
