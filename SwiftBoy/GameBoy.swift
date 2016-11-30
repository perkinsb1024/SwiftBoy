//
//  GameBoy.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/29/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Cocoa

class GameBoy: NSObject {
    var screen : ScreenView?
    var cartridge : Cartridge?
    var processor : Processor?
    
    init(screen : ScreenView) {
        super.init()
        self.screen = screen
        processor = Processor()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameBoy.updateScreen), userInfo: nil, repeats: true)
    }
    
    func loadRom(romFile: String) {
        cartridge = Cartridge(romFile)
        guard let cartridge = cartridge else {
            return
        }
        print(cartridge.logo)
        cartridge.writeRam(data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], offset: 10)
        print(cartridge.readRam(offset: 0, length: 20))
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
        screen?.randomize()
        screen?.update()
    }
}
