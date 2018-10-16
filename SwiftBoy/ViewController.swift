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
        gameBoy?.loadRom(romFile: "/Users/benperkins/dev/Gameboy/asm/joypadTest/joypad.gb")
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        
        debuggerWindow = storyboard.instantiateController(withIdentifier: "debuggerWindowController") as? NSWindowController
        
        if(debuggerWindow != nil) {
            debuggerWindow!.showWindow(self)
            var disassemblyViewController: DisassemblyViewController?
            var registerViewController: RegisterViewController?
            
            disassemblyViewController = (debuggerWindow!.contentViewController?.childViewControllers[0] as! DisassemblyViewController)
            registerViewController = (debuggerWindow!.contentViewController?.childViewControllers[1] as! RegisterViewController)
//            // Todo: This is a mess, can I get it by ID or something cleaner?
//            for vc in (debuggerWindow!.contentViewController?.childViewControllers)! {
//                if vc is DisassemblyViewController {
//                    disassemblyViewController = (vc as! DisassemblyViewController)
//                    break
//                }
//                if vc is RegisterViewController {
//                    registerViewController = (vc as! RegisterViewController)
//                    break
//                }
//            }
            disassemblyViewController?.generateDisassembly(processor: (gameBoy?.processor)!)
            if(disassemblyViewController != nil && registerViewController != nil) {
                gameBoy?.debugger = Debugger(disassemblyViewController: disassemblyViewController!, registerViewController: registerViewController!, processor: (gameBoy?.processor)!)
            }
        } else {
            print("Error, no debugger window")
        }
        //gameBoy?.loadRom(romFile: "/Users/benperkins/Documents/Programming/Gameboy/ROMs/socks.gb")
        gameBoy?.drawLogo(startRow: -16)
        //gameBoy?.start()
    }
}

