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
            disassemblyViewController?.generateDisassembly(processor: (gameBoy?.processor)!)
            if(disassemblyViewController != nil && registerViewController != nil) {
                gameBoy?.debugger = Debugger(disassemblyViewController: disassemblyViewController!, registerViewController: registerViewController!, processor: (gameBoy?.processor)!)
            }
        } else {
            print("Error, no debugger window")
        }
        
        // Register for key events
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
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
    
    override func keyDown(with event: NSEvent) {
        if(event.characters == "\t") {
            print("Step")
            gameBoy?.processor.step();
        }
    }
}

