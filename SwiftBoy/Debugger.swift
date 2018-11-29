//
//  Debugger.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 2/3/18.
//  Copyright © 2018 perkinsb1024. All rights reserved.
//

import Foundation

struct Debugger {
    let disassemblyViewController: DisassemblyViewController!
    let registerViewController: RegisterViewController!
    let processor: Processor!
    
    init(disassemblyViewController: DisassemblyViewController, registerViewController: RegisterViewController, processor: Processor) {
        self.disassemblyViewController = disassemblyViewController
        self.registerViewController = registerViewController
        self.processor = processor
        
        registerViewController.processor = processor
        disassemblyViewController.processor = processor
    }
    
    
}
