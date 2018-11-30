//
//  IORegister.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/29/18.
//  Copyright © 2018 perkinsb1024. All rights reserved.
//

import Foundation

let IO_REGISTER_SIZE = 0x4C
let IO_REGISTER_OFFSET = 0xFF00

/*
 let P1 = 0xFF00
 let SB  = 0xFF01
 let SC = 0xFF02
 let DIV  = 0xFF04
 let TIMA = 0xFF05
 let TMA = 0xFF06
 let TAC = 0xFF07
 let IF = 0xFF0F
 let NR10 = 0xFF10
 let NR11  = 0xFF11
 let NR12 = 0xFF12
 let NR13 = 0xFF13
 let NR14 = 0xFF14
 let NR21  = 0xFF16
 let NR22 = 0xFF17
 let NR23 = 0xFF18
 let NR24 = 0xFF19
 let NR30 = 0xFF1A
 let NR31 = 0xFF1B
 let NR32 = 0xFF1C
 let NR33 = 0xFF1D
 let NR34 = 0xFF1E
 let NR41 = 0xFF20
 let NR42 = 0xFF21
 let NR43 = 0xFF22
 let NR44 = 0xFF23
 let NR50 = 0xFF24
 let NR51 = 0xFF25
 let NR52 = 0xFF26
 let WAV RAM = (0xFF30 - 0xFF3F)
 let LCDC = 0xFF40
 let STAT = 0xFF41
 let SCY = 0xFF42
 let SCX = 0xFF43
 let LY = 0xFF44
 let LYC = 0xFF45
 let DMA = 0xFF46
 let BGP = 0xFF47
 let OBP0 = 0xFF48
 let OBP1 = 0xFF49
 let WY = 0xFF4A
 let WX = 0xFF4B
*/

let READ_ONLY_IO_REGISTERS = [0xFF44]

let WRITE_ONLY_IO_REGISTERS = [0xFF13, 0xFF18, 0xFF1D, 0xFF46]

class IORegister {
    // Some of these are read-only, but we'll guard them manually since a Memory object
    // must either all be read-only or all be read-write
    let registers = Memory(withSize: IO_REGISTER_SIZE, initialValue: 0, readOnly: false)
    
    func readIORegister(_ addr: Int) -> [UInt8]? {
        guard(addr >= IO_REGISTER_OFFSET && addr < IO_REGISTER_OFFSET + IO_REGISTER_SIZE) else {
            return nil
        }
        guard(!WRITE_ONLY_IO_REGISTERS.contains(addr)) else {
            return nil
        }
        // Remove the offset since this block of memory only knows about the IO Registers
        let relativeAddr = addr - IO_REGISTER_OFFSET
        return registers.readDataAt(relativeAddr, length: 1)
    }
    
    @discardableResult
    func writeIORegister(_ addr: Int, data: UInt8) -> Bool {
        // Todo: You will probably need to send a notification when you write to certain hardware registers to notify the emulated hardware to react
        guard(addr >= IO_REGISTER_OFFSET && addr < IO_REGISTER_OFFSET + IO_REGISTER_SIZE) else {
            return false
        }
        guard(!READ_ONLY_IO_REGISTERS.contains(addr)) else {
            return false
        }
        // Remove the offset since this block of memory only knows about the IO Registers
        let relativeAddr = addr - IO_REGISTER_OFFSET
        return registers.writeData(data, toIndex: relativeAddr)
    }
    
    /*
     * Some IO registers are write-only, but we still need a way to read them to simulate hardware
     * Write-only IO registers can only be read with this function, and this function can only
     *  read write-only IO registers
     */
    func _virtualReadIORegister(_ addr: Int) -> [UInt8]? {
        guard(addr >= IO_REGISTER_OFFSET && addr < IO_REGISTER_OFFSET + IO_REGISTER_SIZE) else {
            return nil
        }
        guard(WRITE_ONLY_IO_REGISTERS.contains(addr)) else {
            return nil
        }
        // Remove the offset since this block of memory only knows about the IO Registers
        let relativeAddr = addr - IO_REGISTER_OFFSET
        return registers.readDataAt(relativeAddr, length: 1)
    }
    
    /*
     * Some IO registers are read-only, but we still need a way to simulate the hardware feeding in values
     * Read-only IO registers can only be written with this function, and this function can only
     *  write to read-only IO registers
     */
    @discardableResult
    func _virtualWriteIORegister(_ addr: Int, data: UInt8) -> Bool {
        // Todo: You will probably need to send a notification when you write to certain hardware registers to notify the emulated hardware to react
        guard(addr >= IO_REGISTER_OFFSET && addr < IO_REGISTER_OFFSET + IO_REGISTER_SIZE) else {
            return false
        }
        guard(READ_ONLY_IO_REGISTERS.contains(addr)) else {
            return false
        }
        // Remove the offset since this block of memory only knows about the IO Registers
        let relativeAddr = addr - IO_REGISTER_OFFSET
        return registers.writeData(data, toIndex: relativeAddr)
    }
}
