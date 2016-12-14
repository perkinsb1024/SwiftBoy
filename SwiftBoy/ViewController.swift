//
//  ViewController.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/25/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var screen: ScreenView!
    var gameBoy : GameBoy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameBoy = GameBoy(screenView: screen)
        gameBoy?.loadRom(romFile: "/Users/benperkins/Documents/Programming/Gameboy/ROMs/socks.gb")
        //gameBoy?.drawLogo(startRow: -16)
        gameBoy?.run()
    }
}

