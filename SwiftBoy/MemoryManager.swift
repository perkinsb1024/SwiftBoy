//
//  MemoryManager.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 12/11/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Foundation

/* 
 * Read only + Read/Write memory addresses
 */
let LOWER_BOUND = 0x0
//let INT_VECTOR_START = 0x0
let CART_ROM_BANK_0_START = 0x0//0x100
let CART_ROM_BANK_N_START = 0x4000
let CHAR_DATA_START = 0x8000
let BKG_DATA_0_START = 0x9800
let BKG_DATA_1_START = 0x9C00
let CART_WRAM_START = 0xA000
let GB_WRAM_BANK_0_START = 0xC000
let GB_WRAM_BANK_N_START = 0xD000
let GB_ECHO_WRAM_START = 0xE000
let OAM_START = 0xFE00
let REG_START = 0xFF00
let ZERO_PAGE_START = 0xFF80
let INT_ENABLE_START = 0xFFFF
let UPPER_BOUND = 0x10000

/*
 * Write only memory addresses
 */
let RAM_BANK_ENABLE = 0x0
let ROM_BANK_SELECT_LSB = 0x2000
let ROM_BANK_SELECT_MSB = 0x3000
let RAM_BANK_SELECT = 0x4000
let RAM_ROM_SELECT = 0x6000

/*
 * Write only constant values
 */
let STRICT_RAM_BANK_ENABLING = false
let DISABLE_RAM_BANK_VALUE = 0x0
let ENABLE_RAM_BANK_VALUE = 0xA

class MemoryManager {
    var allowEchoRamRead = false
    var allowEchoRamWrite = false
    let registers: Register
    let stack: Memory
    var cartridge: Cartridge?
    
    init(registers: Register, stack: Memory) {
        self.registers = registers
        self.stack = stack
    }
    
    init(registers: Register, stack: Memory, cartridge: Cartridge) {
        self.registers = registers
        self.stack = stack
        self.cartridge = cartridge
    }
    
    func setCartridge(_ cartridge: Cartridge) {
        self.cartridge = cartridge
    }
    
    func removeCartridge() {
        self.cartridge = nil
    }
    
    // Read multiple bytes from memory
    // Automatically routes to correct device (ROM, RAM, Cartridge, etc.)
    // Returns nil for invalid requests
    func readMemory(offset: Int, length: Int) -> [UInt8]? {
        switch(offset) {
        case offset where offset >= CART_ROM_BANK_0_START && offset + length <= CHAR_DATA_START:
            // Read cartridge ROM
            return self.cartridge?.readRomAt(offset, length: length)
        case offset where offset >= CHAR_DATA_START && offset + length <= BKG_DATA_0_START:
            // Todo: Read character data
            return nil
            //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= BKG_DATA_0_START && offset + length <= CART_WRAM_START:
            // Todo: Read background data
            return nil
            //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= CART_WRAM_START && offset + length <= GB_WRAM_BANK_0_START:
            // Read cartridge WRAM
            return self.cartridge?.readRamAt(offset - 0xA000, length: length)
        case offset where offset >= GB_WRAM_BANK_0_START && offset + length <= GB_ECHO_WRAM_START:
            // Todo: Read internal WRAM
            return nil
            //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= GB_ECHO_WRAM_START && offset + length <= OAM_START:
            // Read internal echo WRAM (if allowed)
            guard self.allowEchoRamRead else {
                return nil
            }
            return self.cartridge?.readRamAt(offset, length: length)
        case offset where offset >= OAM_START && offset + length <= REG_START:
            // Todo: Read OAM (object attribute memory)
            return nil
            //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= REG_START && offset + length <= ZERO_PAGE_START:
            // Todo: Read register
            return nil
            //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= ZERO_PAGE_START && offset + length <= INT_ENABLE_START:
            // Todo: Read zero page
            return nil
            //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= INT_ENABLE_START && offset + length <= UPPER_BOUND:
            // Todo: Read interrupt enable flag
            return nil
            //return self.cartridge.readRomAt(offset, length: length)
        default:
            return nil
        }
    }
    
    // Helper function to write a single byte to memory
    @discardableResult
    func writeMemory(data: UInt8, offset: Int) -> Bool {
        return writeMemory(data: [data], offset: offset, length: 1)
    }
    
    // Write multiple bytes to memory
    // Automatically routes non-memory values to correct behavior
    // Returns true if successful, false on error
    @discardableResult
    func writeMemory(data: [UInt8], offset: Int, length: Int) -> Bool {
        let length = data.count
        switch(offset) {
        case offset where offset >= RAM_BANK_ENABLE && offset + length <= ROM_BANK_SELECT_LSB:
            // Enable or disable cartridge RAM bank
            guard cartridge != nil else {
                return false
            }
            if(STRICT_RAM_BANK_ENABLING) {
                if(data.count == 1 && Int(data[0]) == ENABLE_RAM_BANK_VALUE) {
                    cartridge!.enableRam()
                }
                else if(data.count == 1 && Int(data[0]) == DISABLE_RAM_BANK_VALUE) {
                    cartridge!.disableRam()
                }
                else {
                    return false
                }
            }
            else {
                if((Int(data[0] & 0x0F)) == ENABLE_RAM_BANK_VALUE) {
                    cartridge!.enableRam()
                }
                else {
                    cartridge!.disableRam()
                }
            }
            return true
        case offset where offset >= ROM_BANK_SELECT_LSB && offset + length <= ROM_BANK_SELECT_MSB:
            // Todo: Set least significant bit of cartridge ROM bank
            return false
            //return true
        case offset where offset >= ROM_BANK_SELECT_MSB && offset + length <= RAM_BANK_SELECT:
            // Todo: Set most significant bit of cartridge ROM bank
            return false
            //return true
        case offset where offset >= RAM_BANK_SELECT && offset + length <= RAM_ROM_SELECT:
            // Todo: Set cartridge RAM bank
            return false
            // return true
        case offset where offset >= RAM_ROM_SELECT && offset + length <= CHAR_DATA_START:
            // Todo: Select cartridge RAM/ROM mode
            return false
            //return true
        case offset where offset >= CHAR_DATA_START && offset + length <= BKG_DATA_0_START:
            // Todo: Read character data
            return false
        //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= BKG_DATA_0_START && offset + length <= CART_WRAM_START:
            // Todo: Read background data
            return false
        //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= CART_WRAM_START && offset + length <= GB_WRAM_BANK_0_START:
            // Read cartridge WRAM
            guard cartridge != nil else {
                return false
            }
            return self.cartridge!.writeRam(data, toOffset: offset - 0xA000)
        case offset where offset >= GB_WRAM_BANK_0_START && offset + length <= GB_ECHO_WRAM_START:
            // Todo: Read internal WRAM
            return false
        case offset where offset >= GB_ECHO_WRAM_START && offset + length <= OAM_START:
            // Read internal echo WRAM (if allowed)
            guard cartridge != nil && self.allowEchoRamWrite else {
                return false
            }
            return self.cartridge!.writeRam(data, toOffset: offset)
        case offset where offset >= OAM_START && offset + length <= REG_START:
            // Todo: Read OAM (object attribute memory)
            return false
        //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= REG_START && offset + length <= ZERO_PAGE_START:
            // Todo: Read register
            return false
        //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= ZERO_PAGE_START && offset + length <= INT_ENABLE_START:
            // Todo: Read zero page
            return false
        //return self.cartridge.readRomAt(offset, length: length)
        case offset where offset >= INT_ENABLE_START && offset + length <= UPPER_BOUND:
            // Todo: Read interrupt enable flag
            return false
        //return self.cartridge.readRomAt(offset, length: length)
        default:
            return false
        }
    }
}
