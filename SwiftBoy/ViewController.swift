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

    override func viewDidLoad() {
        super.viewDidLoad()
        updateScreen()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateScreen), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        guard let rr = RomReader("/Users/benperkins/Documents/Programming/Gameboy/ROMs/socks.gb") else {
            print("Could not read ROM file")
            assert(false)
        }
        //rr.printData()
        let processor = Processor()
        processor.dumpRegisters()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func updateScreen() {
        screen.randomize()
        screen.update()
    }

}

