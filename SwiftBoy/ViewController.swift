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
    var debugger: Debugger?
    
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
            disassemblyViewController?.generateDisassembly(processor: (gameBoy?.processor)!)
            gameBoy?.processor.registers.A = 42
            gameBoy?.processor.registers.B = 24
            if(disassemblyViewController != nil && registerViewController != nil) {
                debugger = Debugger(disassemblyViewController: disassemblyViewController!, registerViewController: registerViewController!, gameBoy: gameBoy!)
            }
        } else {
            print("Error, no debugger window")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFlowControl), name: flowControlNotificationName, object: nil)
        //gameBoy?.loadRom(romFile: "/Users/benperkins/Documents/Programming/Gameboy/ROMs/socks.gb")
        gameBoy?.drawLogo(startRow: -16)
//        gameBoy?.start()
    }
    
    func handleFlowControl(_ notification: Notification) {
        guard let action = notification.object as? FlowControlAction else {
            return
        }
        switch(action) {
        case .Stop:
            print("Stop")
            gameBoy?.processor.registers.A += 1
            print(gameBoy?.processor.registers.A)
            gameBoy?.processor.registers.B += 1
            print(gameBoy?.processor.registers.B)
            break
        case .Step:
            print("Step")
            gameBoy?.processor.step();
            break
        case .Run:
            print("Run")
            break
        }
    }
}

