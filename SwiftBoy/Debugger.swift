//
//  Debugger.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 2/3/18.
//  Copyright © 2018 perkinsb1024. All rights reserved.
//

import Foundation

class Debugger {
    let disassemblyViewController: DisassemblyViewController!
    let registerViewController: RegisterViewController!
    let gameBoy: GameBoy!
    
    init(disassemblyViewController: DisassemblyViewController, registerViewController: RegisterViewController, gameBoy: GameBoy) {
        self.disassemblyViewController = disassemblyViewController
        self.registerViewController = registerViewController
        self.gameBoy = gameBoy
        // Pass the registers to the register view controller
        print("Setting registers")
        registerViewController.registers = gameBoy.processor.registers
    }


}
