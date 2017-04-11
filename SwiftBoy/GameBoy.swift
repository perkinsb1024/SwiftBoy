//
//  GameBoy.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/29/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//
    
import Cocoa

class GameBoy: NSObject {
    // Create the virtual hardware
    // Todo: Should probably make a ScreenController that abstracts the ScreenView
    let screen: ScreenController
    let processor: Processor
    let registers: Register
    let flags: Flag
    // Instead of several discrete portions of memory, we'll just make one big block and restrict access at the read/write level
    let internalRam: Memory
    let memoryManager: MemoryManager
    var cartridge: Cartridge?
    
    init(screenView: ScreenView) {
        // Memory
        registers = Register()
        flags = Flag(registers: registers)
        internalRam = Memory(withSize: 0xFFFF, initialValue: 0, readOnly: false)
        // Memory Manager
        memoryManager = MemoryManager(registers: registers, flags: flags, ram: internalRam)
        // Memory Consumers (Processor, IO)
        processor = Processor(registers: registers, flags: flags, ram: internalRam, memoryManager: memoryManager)
        screen = ScreenController(screen: screenView, memoryManager: memoryManager)
        super.init()
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameBoy.updateScreen), userInfo: nil, repeats: true)
    }
    
    func loadRom(romFile: String) {
        cartridge = Cartridge(romFile)
        guard let cartridge = cartridge else {
            return
        }
        memoryManager.setCartridge(cartridge)
        cartridge.enableRam()
        if(cartridge.writeRam([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], toOffset: 10)) {
            print(cartridge.readRamAt(0, length: 20)!)
        }
        cartridge.disableRam()
        processor.PUSH(value: 0xBEEF)
        processor.PUSH(value: 0xDEAD)
        processor.POP(destination: &registers.BC)
        processor.POP(destination: &registers.DE)
        
        let bc = String(format:"%02X", registers.BC)
        print("BC: 0x\(bc)")
        let de = String(format:"%02X", registers.DE)
        print("BC: 0x\(de)")
    }
    
    func run() {
        var sX: UInt8 = 0
        func draw(_ : Timer) {
            screen.drawScreen(sX: sX)

            sX = (sX + 1) % 32
        }
        //Timer.init(timeInterval: 0.25, repeats: true, block: draw)
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: draw)
    }
    
    func drawLogo(startRow : Int) {
        let startCol = 32
        screen.fill(colorCode: 3)
        for i in 0 ..< cartridge!.logo.count {
            let byte = cartridge!.logo[i]
            for j in 0 ..< 8 {
                let colorCode = (Int(byte) >> (7 - j) & 1) == 1 ? 0 : 3
                let dX = ((Int(i / 2) % 12) * 4 + (j % 4)) * 2
                let dY = ((i < 24 ? 0 : 4) + (i % 2) * 2 + (j < 4 ? 0 : 1)) * 2
                
                screen.set(x: startCol + dX, y: startRow + dY, toColor: colorCode)
                screen.set(x: startCol + dX + 1, y: startRow + dY + 1, toColor: colorCode)
                screen.set(x: startCol + dX, y: startRow + dY + 1, toColor: colorCode)
                screen.set(x: startCol + dX + 1, y: startRow + dY, toColor: colorCode)
            }
        }
        screen.update()
        func scroll(_ : Timer) {
            if(startRow < 58) {
                drawLogo(startRow: startRow + 1)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: false, block: scroll)
    }
    
    func updateScreen() {
        screen.randomize()
        screen.update()
    }
}
