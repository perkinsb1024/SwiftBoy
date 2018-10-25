//
//  Register.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/28/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Foundation

class Register: NSObject {
    dynamic var A : UInt8 = 0x01
    dynamic var B : UInt8 = 0x00
    dynamic var C : UInt8 = 0x13
    dynamic var D : UInt8 = 0x00
    dynamic var E : UInt8 = 0xD8
    dynamic var F : UInt8 = 0xB0
    dynamic var H : UInt8 = 0x01
    dynamic var L : UInt8 = 0x4D
    dynamic var SP : UInt16 = 0xFFFE
    dynamic var PC : UInt16 = 0x100
    dynamic var IME : UInt8 = 0
    dynamic var AF : UInt16 {
        get {
            //return UInt16(F) << 8 + UInt16(A)
            return UInt16(A) << 8 + UInt16(F)
        }
        set {
            // A = UInt8(newValue & 0xFF)
            // F = UInt8((newValue >> 8) & 0xFF)
            A = UInt8((newValue >> 8) & 0xFF)
            F = UInt8(newValue & 0xFF)
        }
    }
    dynamic var BC : UInt16 {
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
    dynamic var DE : UInt16 {
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
    dynamic var HL : UInt16 {
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
                                       ("AF", UInt(BC)), ("BC", UInt(BC)), ("DE", UInt(DE)),
                                       ("HL", UInt(HL)), ("SP", UInt(SP)), ("PC", UInt(PC))]
        for (name, value) in names {
            let hexValue = String(format:"%02X", value)
            print("\(name):\t0x\(hexValue)")
        }
    }
    
    dynamic var hexA: String {
        let hex = String(format:"%02X", A)
        return "0x\(hex)"
    }
}
