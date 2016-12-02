//
//  Cartridge.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/27/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Cocoa

class Cartridge: NSObject {
    var rom : Array<UInt8>
    var ram : Array<UInt8>
    var romBank1Offset : Int = 0x4000 // Bank 1 starts at 0x4000
    
    init?(_ romFile : String) {
        // Todo: Set size based on self.ramSize, allow banking
        ram = Array<UInt8>(repeating: 0, count: 0x2000)
        do {
            let romData = try Data.init(contentsOf: URL.init(fileURLWithPath: romFile))
            rom = Array(romData)
        }
        catch {
            return nil
        }
        super.init()
    }
    
    func printLogo() {
        print(logo)
    }
    
    func checksumIsValid() -> Bool {
        var cs : Int = 0
        
        for i in 0 ..< rom.count {
            if(i != 0x14E && i != 0x14F) {
                cs += Int(rom[i])
            }
        }
        return UInt16(cs & 0xFFFF) == checksum
    }
    
    func readRom(offset: Int, length: Int) -> [UInt8] {
        assert(offset + length < rom.count)
        
        return Array(rom[offset ..< offset + length])
    }
    
    func readRam(offset: Int, length: Int) -> [UInt8] {
        assert(offset + length < ram.count)
        return Array(ram[offset ..< offset + length])
    }
    
    func writeRam(data: [UInt8], offset: Int) {
        assert(offset + data.count < ram.count)
        ram.replaceSubrange(offset ..< offset + data.count, with: data)
    }
}

// Memory Bank Controller functions
extension Cartridge {
    // Todo: This assumes banks are 1-indexed, verify that
    func switchBank(bank : UInt8) -> Bool {
        /*
        // This is the code for 0-indexed
        if(pow(Double(2), Double(romSize + 1)) > Double(bank)) {
            romBank1Offset = 0x4000 * Int(bank + 1)
        */
        // Todo: This math only works for ROM size 0-6, make an enum
        if(pow(Double(2), Double(romSize + 1)) >= Double(bank)) {
            romBank1Offset = 0x4000 * Int(bank)
            return true
        }
        return false
    }
}

// Cartridge contansts
extension Cartridge {
    var logo : [UInt8] {
        return readRom(offset: 0x104, length: 0x30)
    }
    var title : [UInt8] {
        return readRom(offset: 0x134, length: 0x15)
    }
    var color : Bool {
        return readRom(offset: 0x143, length: 0x1)[0] == 0x80
    }
    var licenseeHigh : UInt8 {
        return readRom(offset: 0x144, length: 0x1)[0]
    }
    var licenseeLow : UInt8 {
        return readRom(offset: 0x145, length: 0x1)[0]
    }
    var sgb : Bool {
        return readRom(offset: 0x146, length: 0x1)[0] == 0x03
    }
    var cartridgeType : UInt8 {
        return readRom(offset: 0x147, length: 0x1)[0]
    }
    var romSize : UInt8 {
        return readRom(offset: 0x148, length: 0x1)[0]
    }
    var ramSize : UInt8 {
        return readRom(offset: 0x149, length: 0x1)[0]
    }
    var destCode : UInt8 {
        return readRom(offset: 0x14A, length: 0x1)[0]
    }
    var licenseeeCode : UInt8 {
        return readRom(offset: 0x14B, length: 0x1)[0]
    }
    var romVersion : UInt8 {
        return readRom(offset: 0x14C, length: 0x1)[0]
    }
    var complement : UInt8 {
        return readRom(offset: 0x14D, length: 0x1)[0]
    }
    var checksum : UInt16 {
        return UInt16((readRom(offset: 0x14E, length: 0x1)[0])) << 8 +
                        UInt16((readRom(offset: 0x14F, length: 0x1)[0]))
    }
    
}


