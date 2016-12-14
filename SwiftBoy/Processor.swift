//
//  Processor.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/27/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

class Processor {
    let registers: Register
    let stack: Memory
    let memoryManager: MemoryManager
    
    init(registers: Register, stack: Memory, memoryManager: MemoryManager) {
        self.registers = registers
        self.stack = stack
        self.memoryManager = memoryManager
    }
    
    func dumpRegisters() {
        registers.printAll()
    }
    
    func getOpcodeLength(_ opcode : UInt8) -> Int {
        switch(opcode) {
        case 0x06, 0x0E, 0x10, 0x16, 0x18, 0x1E, 0x20, 0x26, 0x28, 0x2E, 0x30, 0x36, 0x38, 0x3E,
             0xC6, 0xCB, 0xCE, 0xD6, 0xDE, 0xE0, 0xE6, 0xE8, 0xEE, 0xF0, 0xF6, 0xFE:
            return 2
        case 0x01, 0x08, 0x11, 0x21, 0x31, 0xC2, 0xC3, 0xC4, 0xCA, 0xCC, 0xCD, 0xD2, 0xD4, 0xDA, 0xDC, 0xEA, 0xFA:
            return 3
        case _: // All the rest are 1
            return 1
        }
    }
}
