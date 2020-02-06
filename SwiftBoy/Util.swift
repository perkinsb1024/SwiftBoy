//
//  Util.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 3/10/17.
//  Copyright © 2017 perkinsb1024. All rights reserved.
//

import Foundation

func setBit(byte: inout UInt8, position: UInt8, value: Bool) {
    guard(position <= 7) else {
        return
    }
    let mask = UInt8(1 << position);
    if(value) {
        byte |= mask;
    } else {
        byte &= (~mask);
    }
}

func setBit(byte: inout UInt8, position: UInt8, value: UInt8) {
    guard(value <= 1) else {
        return
    }
    setBit(byte: &byte, position: position, value: value == 1)
}

func getBit(byte: UInt8, position: UInt8) -> UInt8 {
    guard(position <= 7) else {
        return 0
    }
    return (byte >> position) & 1
}

func makeWord(low: UInt8, high: UInt8) -> UInt16 {
    return UInt16(high) << 8 | UInt16(low)
}
