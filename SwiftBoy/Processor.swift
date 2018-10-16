//
//  Processor.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/27/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

enum Conditional {
    case NZ
    case Z
    case NC
    case C
}

class Processor {
    let flags: Flag
    let registers: Register
    let ram: Memory
    let memoryManager: MemoryManager
    var halted: Bool = true // Todo: Use this
    
    init(registers: Register, flags: Flag, ram: Memory, memoryManager: MemoryManager) {
        self.registers = registers
        self.ram = ram
        self.memoryManager = memoryManager
        self.flags = flags
    }
    
    func dumpRegisters() {
        registers.printAll()
    }
    
    func validateConditional(_ condition: Conditional) -> Bool {
        switch condition {
        case .NZ:
            return flags.Z == 0
        case .Z:
            return flags.Z != 0
        case .NC:
            return flags.C == 0
        case .C:
            return flags.C != 0
        }
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
    
    func step() {
        let command = getNextCommand()!
        // Todo: Triple check that it's safe to increment PC before processing the command
        registers.PC += UInt16(command.count)
        parseCommand(command)
    }
    
    func getNextCommand() -> [UInt8]? {
        return getCommand(atAddress: registers.PC)
    }
    
    func getCommand(atAddress address: UInt16) -> [UInt8]? {
        guard Int(address) < memoryManager.CHAR_DATA_START else {
            return nil
        }
        // Get the opcode
        let opcode = memoryManager.readMemory(offset: Int(address), length: 1)![0]
        // Return the full command
        return memoryManager.readMemory(offset: Int(address), length: getOpcodeLength(opcode))!
    }
}
