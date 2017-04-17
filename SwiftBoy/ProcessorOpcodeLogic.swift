//
//  ProcessorOpcodeLogic.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 12/22/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Foundation

extension Processor {
    // Opcode logic
    // Add a number or register contents plus carry flag to register
    func ADC(destination: inout UInt8, source: UInt8) {
        ADD(destination: &destination, source: source &+ flags.C)
    }
    
    // Add a the contents of a memory address plus carry flag to register
    func ADC(destination: inout UInt8, sourceAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        ADD(destination: &destination, source: data[0] &+ flags.C)
    }
    
    // Add contents of register or number to register
    func ADD(destination: inout UInt8, source: UInt8) {
        let result = destination &+ source
        flags.C = destination > result ? 1 : 0
        // Todo: Double check this
        flags.H = (destination & 0x0F) &+ (source & 0xF0) > 127 ? 1 : 0
        flags.N = 0
        flags.Z = result == 0 ? 1 : 0
        destination = result
    }
    
    // Add contents of register or number to a register pair
    func ADD(destination: inout UInt16, source: UInt16) {
        let result = destination &+ source
        flags.C = destination > result ? 1 : 0
        // Todo: Double check this, probably wrong for words
        flags.H = (destination & 0x0F) &+ (source & 0xF0) > 127 ? 1 : 0
        flags.N = 0
        // Zero is not set for this version of ADD
        destination = result
    }
    
    // Add contents of register or number to register pair
    func ADD(destination: inout UInt8, sourceAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        ADD(destination: &destination, source: data[0])
    }
    
    func AND(destination: inout UInt8, source: UInt8) {
        let resultFinal = destination & source
        flags.C = 0
        flags.H = 1
        flags.N = 0
        flags.Z = resultFinal == 0 ? 1 : 0
        destination = resultFinal
    }
    
    func AND(destination: inout UInt8, sourceAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        AND(destination: &destination, source: data[0])
    }
    
    func BIT(bit: Int, source: UInt8) {
        // Todo: Is this how the Gameboy would handle numbers >= 8?
        let bit = (bit & 0x7)
        flags.H = 1
        flags.N = 0
        flags.Z = UInt8((Int(source) >> bit) & 0x01)
    }
    
    func BIT(bit: Int, sourceAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        BIT(bit: bit, source: data[0])
    }
    
    func CALL(address: UInt16) {
        PUSH(value: registers.PC)
        registers.PC = address
    }
    
    func CALL(address: UInt16, condition: Conditional) {
        if(validateConditional(condition)) {
            PUSH(value: registers.PC)
            registers.PC = address
        }
    }
    
    func CCF() {
        registers.C = registers.C == 0 ? 1 : 0
    }
    
    func CP(sourceA: UInt8, sourceB: UInt8) {
        flags.C = (sourceA < sourceB) ? 1 : 0
        flags.H = 0 // Todo: How is this calculated?
        flags.N = 1
        flags.Z = (sourceA == sourceB) ? 1 : 0
    }
    
    func CP(sourceA: UInt8, sourceBAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceBAddress, length: 1)!
        CP(sourceA: sourceA, sourceB: data[0])
    }
    
    func CPL(destination: inout UInt8) {
        destination = ~destination
        flags.H = 1
        flags.N = 1
    }
    
    func DAA(destination: inout UInt8) {
        // Todo: Double, triple check this logic. Have not verified at all
        var adjust: UInt8 = 0x0
        if(destination & 0x0F >= 0x0A) {
            adjust = adjust &+ 0x06
        }
        if(flags.C == 1 || (destination >> 4) & 0x0F &+ flags.H >= 0x0A) {
            adjust = adjust &+ 0x60
        }
        if(adjust > 0) {
            ADD(destination: &destination, source: adjust)
        }
    }
    
    // For registers
    func DEC(destination: inout UInt8) {
        let resultFinal = destination &- 1
        flags.H = 0 // Todo: How is this calculated?
        flags.N = 1
        flags.Z = resultFinal == 0 ? 1 : 0
        destination = resultFinal
    }
    
    // For register pairs
    func DEC(destination: inout UInt16) {
        // This one doesn't affect status flags apparently
        destination = destination &- 1
    }
    
    // For memory address
    func DEC(destinationAddress: UInt16) {
        let value = memoryManager.readMemory(offset: destinationAddress, length: 1)!
        let resultFinal = value[0] &- UInt8(1)
        memoryManager.writeMemory(data: resultFinal, offset: destinationAddress)
        flags.H = 0 // Todo: How is this calculated?
        flags.N = 1
        flags.Z = resultFinal == 0 ? 1 : 0
    }
    
    func DI() {
        registers.IME = 0
    }
    
    func EI() {
        registers.IME = 1
    }
    
    func HALT() {
        halted = true
    }
    
    // For registers
    func INC(destination: inout UInt8) {
        let resultFinal = destination &+ 1
        flags.H = (Int(destination) & 0x0F) &+ 1 > 127 ? 1 : 0
        flags.N = 1
        flags.Z = resultFinal == 0 ? 1 : 0
        destination = resultFinal
    }
    
    // For register pairs
    func INC(destination: inout UInt16) {
        // This one doesn't affect status flags apparently
        destination = destination &+ 1
    }
    
    // For memory address
    func INC(destinationAddress: UInt16) {
        let value = memoryManager.readMemory(offset: destinationAddress, length: 1)!
        let resultFinal = value[0] &+ UInt8(1)
        memoryManager.writeMemory(data: resultFinal, offset: destinationAddress)
        flags.H = (Int(value[0]) & 0x0F) &+ 1 > 127 ? 1 : 0
        flags.N = 1
        flags.Z = resultFinal == 0 ? 1 : 0
    }
    
    // Jump to an address
    func JP(address: UInt16) {
        registers.PC = address
    }
    
    // Jump to an address if condition is true
    func JP(address: UInt16, condition: Conditional) {
        if(validateConditional(condition)) {
            JP(address: address);
        }
    }
    
    // Jump to an address that's stored in a memory location addressAtAddress
    func JP(addressAtAddress: UInt16) {
        let data = memoryManager.readMemory(offset: addressAtAddress, length: 1)!
        JP(address: UInt16(data[0]))
    }
    
    func JR(offset: UInt8) {
        registers.PC = registers.PC &+ UInt16(offset)
    }
    
    func JR(offset: UInt8, condition: Conditional) {
        if(validateConditional(condition)) {
            JR(offset: offset)
        }
    }
    
    // Load contents of a register or a number to another register
    func LD(source: UInt8, destination: inout UInt8) {
        destination = source
    }
    
    // Load a word to a register pair
    func LD(source: UInt16, destination: inout UInt16) {
        destination = source
    }
    
    // Load contents of memory to another address
    func LD(sourceAddress: UInt16, destinationAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)
        memoryManager.writeMemory(data: data!, offset: destinationAddress)
    }
    
    // Load contents of memory to a register
    func LD(sourceAddress: UInt16, destination: inout UInt8) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        destination = data[0]
    }
    
    // Load contents of a register to memory address
    func LD(source: UInt8, destinationAddress: UInt16) {
        memoryManager.writeMemory(data: source, offset: destinationAddress)
    }
    
    // Load contents of memory address to register and decrement source address
    func LDD(sourceAddress: inout UInt16, destination: inout UInt8) {
        LD(sourceAddress: sourceAddress, destination: &destination)
        DEC(destination: &sourceAddress)
    }
    
    // Load contents of register to memory address and increment destination address
    func LDD(source: inout UInt8, destinationAddress: inout UInt16) {
        LD(source: source, destinationAddress: destinationAddress)
        DEC(destination: &destinationAddress)
    }
    
    // Load contents of memory address into register
    func LDH(sourceAddress: UInt8, destination: inout UInt8) {
        LD(sourceAddress: 0xFF00 | UInt16(sourceAddress), destination: &destination)
    }
    
    // Load contents of a register into memory
    func LDH(source: UInt8, destinationAddress: UInt8) {
        LD(source: source, destinationAddress: 0xFF00 | UInt16(destinationAddress))
    }
    
    // Load contents of memory address to register and increment source address
    func LDI(sourceAddress: inout UInt16, destination: inout UInt8) {
        LD(sourceAddress: sourceAddress, destination: &destination)
        INC(destination: &sourceAddress)
    }
    
    // Load contents of register to memory address and increment destination address
    func LDI(source: inout UInt8, destinationAddress: inout UInt16) {
        LD(source: source, destinationAddress: destinationAddress)
        INC(destination: &destinationAddress)
    }
    
    func LD_HL_SP() {
        // Todo: Double check that this is right
        let resultFinal = UInt16(registers.SP) << 8
        flags.C = 0 // Todo: How is this calculated?
        flags.H = 0 // Todo: How is this calculated?
        flags.N = 0
        flags.Z = 0
        registers.HL = resultFinal
    }
    
    func NOP() {
        return
    }
    
    func OR(destination: inout UInt8, source: UInt8) {
        let resultFinal = destination | source
        flags.C = 0
        flags.H = 1
        flags.N = 0
        flags.Z = resultFinal == 0 ? 1 : 0
        destination = resultFinal
    }
    
    func OR(destination: inout UInt8, sourceAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        OR(destination: &destination, source: data[0])
    }
    
    func POP(destination: inout UInt16) {
        // Verify: Does Gameboy do any safety checks?
        let data = memoryManager.readMemory(offset: Int(registers.SP), length: 2)!
        registers.SP = registers.SP &+ 2
        destination = UInt16(data[0]) << 8 &+ UInt16(data[1])
    }
    
    func PUSH(value: UInt16) {
        // Verify: Does Gameboy do any safety checks?
        registers.SP = registers.SP &- 2
        memoryManager.writeMemory(data: [UInt8((value >> 8) & 0xFF), UInt8(value & 0xFF)], offset: Int(registers.SP))
    }
    
    // For registers
    func RES(bit: UInt8, destination: inout UInt8) {
        destination &= ~(UInt8(1) << (bit & 0x03))
    }
    
    // For memory address
    func RES(bit: UInt8, destinationAddress: UInt16) {
        let data = memoryManager.readMemory(offset: destinationAddress, length: 1)!
        let resultFinal = data[0] & ~(UInt8(1) << (bit & 0x03))
        memoryManager.writeMemory(data: resultFinal, offset: destinationAddress)
    }
    
    func RET() {
        var address: UInt16 = 0
        POP(destination: &address)
        JP(address: address)
    }
    
    func RET(condition: Conditional) {
        if(validateConditional(condition)) {
            RET()
        }
    }
    
    func RETI() {
        RET()
        EI()
    }
    
    func RL(operand: inout UInt8) {
        let oldBit = getBit(byte: operand, position: 7)
        let oldCarry = flags.C
        operand = operand << 1
        operand = operand &+ oldCarry
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
    }
    
    func RL(operandAddress: UInt16) {
        let data = memoryManager.readMemory(offset: operandAddress, length: 1)!
        var operand = data[0]
        let oldBit = getBit(byte: operand, position: 7)
        let oldCarry = flags.C
        operand = operand << 1
        operand = operand &+ oldCarry
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
        memoryManager.writeMemory(data: operand, offset: operandAddress)
    }
    
    func RLC(operand: inout UInt8) {
        let oldBit = getBit(byte: operand, position: 7)
        operand = operand << 1
        operand = operand &+ oldBit
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
    }
    
    func RLC(operandAddress: UInt16) {
        let data = memoryManager.readMemory(offset: operandAddress, length: 1)!
        var operand = data[0]
        let oldBit = getBit(byte: operand, position: 7)
        operand = operand << 1
        operand = operand &+ oldBit
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
        memoryManager.writeMemory(data: operand, offset: operandAddress)
    }
    
    func RR(operand: inout UInt8) {
        let oldBit = getBit(byte: operand, position: 0)
        let oldCarry = flags.C
        operand = operand >> 1
        setBit(byte: &operand, position: 7, value: oldCarry)
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
    }
    
    func RR(operandAddress: UInt16) {
        let data = memoryManager.readMemory(offset: operandAddress, length: 1)!
        var operand = data[0]
        let oldBit = getBit(byte: operand, position: 0)
        let oldCarry = flags.C
        operand = operand >> 1
        setBit(byte: &operand, position: 7, value: oldCarry)
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
        memoryManager.writeMemory(data: operand, offset: operandAddress)
    }
    
    func RRC(operand: inout UInt8) {
        let oldBit = getBit(byte: operand, position: 7)
        operand = operand >> 1
        setBit(byte: &operand, position: 7, value: oldBit)
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
    }
    
    func RRC(operandAddress: UInt16) {
        let data = memoryManager.readMemory(offset: operandAddress, length: 1)!
        var operand = data[0]
        let oldBit = getBit(byte: operand, position: 7)
        operand = operand >> 1
        setBit(byte: &operand, position: 7, value: oldBit)
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
        memoryManager.writeMemory(data: operand, offset: operandAddress)
    }
    
    func RST(destinationAddress: UInt16) {
        PUSH(value: registers.PC)
        JP(address: destinationAddress)
    }
    
    func SBC(destination: inout UInt8, source: UInt8) {
        SUB(destination: &destination, source: (source &+ flags.C))
    }
    
    func SBC(destination: inout UInt8, sourceAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        SUB(destination: &destination, source: (data[0] &+ flags.C))
    }
    
    func SCF() {
        // Todo: Verify that Z is left alone
        flags.N = 0
        flags.H = 0
        flags.C = 1
    }
    
    func SET(bit: UInt8, destination: inout UInt8) {
        guard(bit < 8) else {
            return
        }
        setBit(byte: &destination, position: bit, value: true)
    }
    
    func SET(bit: UInt8, destinationAddress: UInt16) {
        guard(bit < 8) else {
            return
        }
        var data = memoryManager.readMemory(offset: destinationAddress, length: 1)!
        setBit(byte: &data[0], position: bit, value: true)
        memoryManager.writeMemory(data: data, offset: destinationAddress)
    }
    
    func SLA(operand: inout UInt8) {
        let oldBit = getBit(byte: operand, position: 7)
        operand = operand << 1
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
    }
    
    func SLA(operandAddress: UInt16) {
        let data = memoryManager.readMemory(offset: operandAddress, length: 1)!
        var operand = data[0]
        let oldBit = getBit(byte: operand, position: 7)
        operand = operand << 1
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
        memoryManager.writeMemory(data: operand, offset: operandAddress)
    }
    
    func SRA(operand: inout UInt8) {
        let oldBit = getBit(byte: operand, position: 0)
        operand = operand >> 1
        setBit(byte: &operand, position: 7, value: oldBit)
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
    }
    
    func SRA(operandAddress: UInt16) {
        let data = memoryManager.readMemory(offset: operandAddress, length: 1)!
        var operand = data[0]
        let oldBit = getBit(byte: operand, position: 0)
        operand = operand >> 1
        setBit(byte: &operand, position: 7, value: oldBit)
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
        memoryManager.writeMemory(data: operand, offset: operandAddress)
    }
    
    func SRL(operand: inout UInt8) {
        let oldBit = getBit(byte: operand, position: 0)
        operand = operand >> 1
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
    }
    
    func SRL(operandAddress: UInt16) {
        let data = memoryManager.readMemory(offset: operandAddress, length: 1)!
        var operand = data[0]
        let oldBit = getBit(byte: operand, position: 0)
        operand = operand >> 1
        flags.C = oldBit
        flags.H = 0
        flags.N = 0
        flags.Z = operand == 0 ? 1 : 0
        memoryManager.writeMemory(data: operand, offset: operandAddress)
    }
    
    func STOP() {
        // Todo: Double check that this is what halted is used for
        halted = true
    }
    
    func SUB(destination: inout UInt8, source: UInt8) {
        let result = destination &- source
        flags.C = result > destination ? 1 : 0
        // Todo: How is this calculated
        flags.H = 0
        flags.N = 1
        flags.Z = result == 0 ? 1 : 0
        destination = result
    }
    
    func SWAP(destination: inout UInt8) {
        let lowNibble = destination & 0x0F
        let highNibble = destination & 0xF0
        flags.Z = destination == 0 ? 1 : 0
        destination = (highNibble >> 4) | (lowNibble << 4)
    }
    
    func XOR(destination: inout UInt8, source: UInt8) {
        let resultFinal = source ^ destination
        flags.C = 0
        flags.H = 0
        flags.N = 0
        flags.Z = resultFinal == 0 ? 1 : 0
        destination = resultFinal
    }
    
    func XOR(destination: inout UInt8, sourceAddress: UInt16) {
        let data = memoryManager.readMemory(offset: sourceAddress, length: 1)!
        XOR(destination: &destination, source: data[0])
    }
    
    func TEMPLATE(source: UInt16) {
        let resultTemp = source
        let resultFinal = UInt8(resultTemp)
        flags.C = 0
        flags.H = 0
        flags.N = 0
        flags.Z = resultFinal == 0 ? 1 : 0
    }
}
