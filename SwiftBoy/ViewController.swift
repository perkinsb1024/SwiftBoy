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
    var debuggerWindow: NSWindowController?
    var gameBoy: GameBoy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameBoy = GameBoy(screenView: screen)
        gameBoy?.loadRom(romFile: "/Users/benperkins/Documents/Programming/Gameboy/asm/joypadTest/joypad.gb")
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        debuggerWindow = storyboard.instantiateController(withIdentifier: "debuggerWindowController") as? NSWindowController
        
        if(debuggerWindow != nil) {
            debuggerWindow!.showWindow(self)
            // Todo: This is a mess, can I get it by ID or something cleaner?
            var disassemblyViewController: DisassemblyViewController?
            
            for vc in (debuggerWindow!.contentViewController?.childViewControllers)! {
                if vc is DisassemblyViewController {
                    disassemblyViewController = vc as! DisassemblyViewController
                    break
                }
            }
            disassemblyViewController?.generateDisassembly(processor: (gameBoy?.processor)!)
        } else {
            print("Error, no debugger window")
        }
        //gameBoy?.loadRom(romFile: "/Users/benperkins/Documents/Programming/Gameboy/ROMs/socks.gb")
        //gameBoy?.drawLogo(startRow: -16)
        //gameBoy?.start()
    }
}

