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
    }
    
    func start() {
        registers.PC = 0x100
        registers.SP = 0xFFFE
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: run)
    }
    
    func run(_ : Timer) {
        while(!processor.halted) {
            processor.step()
        }
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
