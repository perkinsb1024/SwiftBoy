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
        gameBoy?.loadRom(romFile: (Bundle.main.url(forResource: "joypad", withExtension: "gb")?.path)!)
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleDelayChange), name: emulatorDelayChangeNotificationName, object: nil)
        gameBoy?.reset()
    }
    
    func handleFlowControl(_ notification: Notification) {
        guard let action = notification.object as? FlowControlAction else {
            return
        }
        switch(action) {
        case .Stop:
            print("Stop")
            gameBoy?.emuStop()
            break
        case .Step:
            print("Step")
            gameBoy?.emuStep()
            break
        case .Run:
            print("Run")
            gameBoy?.emuStart()
            break
        }
    }
    
    func handleDelayChange(_ notification: Notification) {
        guard let delayMs = notification.object as? Int else {
            return
        }
        gameBoy?.emuSetDelay(ms: delayMs)
    }
    
    override func keyDown(with event: NSEvent) {
        if(event.characters == "\t") {
            print("Step")
            gameBoy?.emuStep()
        }
    }
}

