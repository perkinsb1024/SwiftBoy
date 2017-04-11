//
//  Flag.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 12/22/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

//
//  Register.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/28/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Foundation

// Todo: Verify that these are the right positions
let C_POS: UInt8 = 3;
let H_POS: UInt8 = 2;
let N_POS: UInt8 = 1;
let Z_POS: UInt8 = 0;

class Flag {
    let registers : Register
    var C : UInt8 {
        set {
            guard(newValue <= 1) else {
                return;
            }
            setBit(byte: &registers.F, position: C_POS, value: newValue != 0);
        }
        get {
            return getBit(byte: registers.F, position: C_POS)
        }
    }
    var H : UInt8 {
        set {
            guard(newValue <= 1) else {
                return;
            }
            setBit(byte: &registers.F, position: H_POS, value: newValue != 0);
        }
        get {
            return getBit(byte: registers.F, position: H_POS)
        }
    }
    var N : UInt8 {
        set {
            guard(newValue <= 1) else {
                return;
            }
            setBit(byte: &registers.F, position: N_POS, value: newValue != 0);
        }
        get {
            return getBit(byte: registers.F, position: N_POS)
        }
    }
    var Z : UInt8 {
        set {
            guard(newValue <= 1) else {
                return;
            }
            setBit(byte: &registers.F, position: Z_POS, value: newValue != 0);
        }
        get {
            return getBit(byte: registers.F, position: Z_POS)
        }
    }
    
    init(registers : Register) {
        self.registers = registers
    }
    
    func printAll() {
        let names : [(String, UInt)] = [("C", UInt(C)), ("H", UInt(H)), ("N", UInt(N)), ("Z", UInt(Z))]
        for (name, value) in names {
            let hexValue = String(format:"%02X", value)
            print("\(name):\t0x\(hexValue)")
        }
    }
}
