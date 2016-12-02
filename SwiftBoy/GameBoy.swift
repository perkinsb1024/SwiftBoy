//
//  GameBoy.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/29/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Cocoa

class GameBoy: NSObject {
    var screen : ScreenView
    var cartridge : Cartridge?
    var processor : Processor
    
    init(screen : ScreenView) {
        self.screen = screen
        processor = Processor()
        super.init()
        //Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameBoy.updateScreen), userInfo: nil, repeats: true)
    }
    
    func loadRom(romFile: String) {
        cartridge = Cartridge(romFile)
        guard let cartridge = cartridge else {
            return
        }
        cartridge.writeRam(data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], offset: 10)
        print(cartridge.readRam(offset: 0, length: 20))
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
    
    func readMemory(offset: Int, length: Int) -> [UInt8]? {
        // Todo: Remove magic numbers
        switch(offset) {
        case offset where offset >= 0 && offset + length < 0x8000:
            return cartridge?.readRom(offset: offset, length: length)
        case offset where offset >= 0x8000 && offset + length < 0x8000:
            return [UInt8](repeating: 0, count: length)
        case offset where offset >= 0xA000 && offset + length < 0xBFFF:
            return  cartridge?.readRam(offset: offset - 0xA000, length: length)
        default:
            return nil
        }
    }
    
    func updateScreen() {
        screen.randomize()
        screen.update()
    }
}
