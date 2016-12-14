//
//  Cartridge.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/27/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//
import Cocoa

class Cartridge {
    var rom: Memory
    var ram: Memory
    var romBankOffset : Int = 0x4000 // Bank 1 starts at 0x4000
    var ramEnabled: Bool = false
    
    init?(_ romFile : String) {
        // Todo: Set size based on self.ramSize, allow banking
        let tempRam = Memory(withSize: 0x2000, initialValue: 0, asRom: false)
        let tempRom = Memory(withContentsOfFile: romFile, asRom: true)
        guard tempRom != nil else {
            return nil
        }
        ram = tempRam
        rom = tempRom!
    }
    
    func printLogo() {
        print(logo)
    }
    
    func checksumIsValid() -> Bool {
        var cs : Int = 0
        
        for i in 0 ..< rom.count {
            if(i != 0x14E && i != 0x14F) {
                cs += Int(rom.readDataAt(i)!)
            }
        }
        return UInt16(cs & 0xFFFF) == checksum
    }
    
    func readRomAt(_ offset: Int, length: Int) -> [UInt8]? {
        guard(offset >= 0x100 && offset + length <= rom.count) else {
            return nil
        }
        
        return rom.readDataAt(offset ..< offset + length)
    }
    
    func readRamAt(_ offset: Int, length: Int) -> [UInt8]? {
        guard ramEnabled else {
            return nil
        }
        return ram.readDataAt(offset ..< offset + length)
    }
    
    @discardableResult
    func writeRam(_ data: [UInt8], toOffset offset: Int) -> Bool {
        guard ramEnabled else {
            return false
        }
        return ram.writeData(data, toRange: offset ..< offset + data.count)
    }
    
    func enableRam() {
        ramEnabled = true
    }
    
    func disableRam() {
        ramEnabled = false
    }
}

// Memory Bank Controller functions
extension Cartridge {
    func switchBank(bank : UInt8) -> Bool {
        var bank = bank
        if(bank == 0) { bank = 1; }
        // Todo: This math only works for ROM size 0-6, make an enum
        if(pow(Double(2), Double(romSize + 1)) >= Double(bank)) {
            romBankOffset = 0x4000 * Int(bank)
            return true
        }
        return false
    }
}

// Cartridge contansts
extension Cartridge {
    var logo : [UInt8] {
        return readRomAt(0x104, length: 0x30)!
    }
    var title : [UInt8] {
        return readRomAt(0x134, length: 0x15)!
    }
    var color : Bool {
        return readRomAt(0x143, length: 0x1)![0] == 0x80
    }
    var licenseeHigh : UInt8 {
        return readRomAt(0x144, length: 0x1)![0]
    }
    var licenseeLow : UInt8 {
        return readRomAt(0x145, length: 0x1)![0]
    }
    var sgb : Bool {
        return readRomAt(0x146, length: 0x1)![0] == 0x03
    }
    var cartridgeType : UInt8 {
        return readRomAt(0x147, length: 0x1)![0]
    }
    var romSize : UInt8 {
        return readRomAt(0x148, length: 0x1)![0]
    }
    var ramSize : UInt8 {
        return readRomAt(0x149, length: 0x1)![0]
    }
    var destCode : UInt8 {
        return readRomAt(0x14A, length: 0x1)![0]
    }
    var licenseeCode : UInt8 {
        return readRomAt(0x14B, length: 0x1)![0]
    }
    var romVersion : UInt8 {
        return readRomAt(0x14C, length: 0x1)![0]
    }
    var complement : UInt8 {
        return readRomAt(0x14D, length: 0x1)![0]
    }
    var checksum : UInt16 {
        return UInt16((readRomAt(0x14E, length: 0x1)![0])) << 8 +
                        UInt16((readRomAt(0x14F, length: 0x1)![0]))
    }
    
}


