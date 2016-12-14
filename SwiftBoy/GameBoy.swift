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
    let stack: Memory
    let memoryManager: MemoryManager
    var cartridge: Cartridge?
    
    init(screenView: ScreenView) {
        // Memory
        registers = Register()
        stack = Memory(withSize: 127, initialValue: 0, asRom: false)
        // Memory Manager
        memoryManager = MemoryManager(registers: registers, stack: stack)
        // Memory Consumers (Processor, IO)
        processor = Processor(registers: registers, stack: stack, memoryManager: memoryManager)
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
    }
        
    func run() {
        var sX: UInt8 = 0
        func draw(_ : Timer) {
            screen.drawScreen(sX: sX)

            sX = (sX + 1) % 32
        }
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
