//
//  Register.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/28/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Foundation

struct Register {
    var A : UInt8 = 0
    var B : UInt8 = 0
    var C : UInt8 = 0
    var D : UInt8 = 0
    var E : UInt8 = 0
    var F : UInt8 = 0
    var H : UInt8 = 0
    var L : UInt8 = 0
    var SP : UInt16 = 0
    var PC : UInt16 = 0
    var BC : UInt16 {
        get {
            //return UInt16(C) << 8 + UInt16(B)
            return UInt16(B) << 8 + UInt16(C)
        }
        set {
            // B = UInt8(newValue & 0xFF)
            // C = UInt8((newValue >> 8) & 0xFF)
            B = UInt8((newValue >> 8) & 0xFF)
            C = UInt8(newValue & 0xFF)
        }
    }
    var DE : UInt16 {
        get {
            //return UInt16(E) << 8 + UInt16(D)
            return UInt16(D) << 8 + UInt16(E)
        }
        set {
            // D = UInt8(newValue & 0xFF)
            // E = UInt8((newValue >> 8) & 0xFF)
            D = UInt8((newValue >> 8) & 0xFF)
            E = UInt8(newValue & 0xFF)
        }
    }
    var HL : UInt16 {
        get {
            //return UInt16(L) << 8 + UInt16(H)
            return UInt16(H) << 8 + UInt16(L)
        }
        set {
            // H = UInt8(newValue & 0xFF)
            // L = UInt8((newValue >> 8) & 0xFF)
            H = UInt8((newValue >> 8) & 0xFF)
            L = UInt8(newValue & 0xFF)
        }
    }
    
    func printAll() {
        let names : [(String, UInt)] = [("A", UInt(A)), ("B", UInt(B)), ("C", UInt(C)), ("D", UInt(D)),
                                       ("E", UInt(E)), ("F", UInt(F)), ("H", UInt(H)), ("L", UInt(L)),
                                       ("BC", UInt(BC)), ("DE", UInt(DE)), ("HL", UInt(HL)),
                                       ("SP", UInt(SP)), ("PC", UInt(PC))]
        for (name, value) in names {
            let hexValue = String(format:"%02X", value)
            print("\(name):\t0x\(hexValue)")
        }
    }
}