//
//  RegisterViewController.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 4/15/17.
//  Copyright © 2017 perkinsb1024. All rights reserved.
//

import Cocoa

class RegisterViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet var aValue: NSTextField!
    @IBOutlet var fValue: NSTextField!
    @IBOutlet var bValue: NSTextField!
    @IBOutlet var cValue: NSTextField!
    @IBOutlet var dValue: NSTextField!
    @IBOutlet var eValue: NSTextField!
    @IBOutlet var hValue: NSTextField!
    @IBOutlet var lValue: NSTextField!
    
    @IBOutlet var afValue: NSTextField!
    @IBOutlet var bcValue: NSTextField!
    @IBOutlet var deValue: NSTextField!
    @IBOutlet var hlValue: NSTextField!
    @IBOutlet var spValue: NSTextField!
    @IBOutlet var pcValue: NSTextField!
    
    @IBOutlet var zFlagValue: NSTextField!
    @IBOutlet var cFlagValue: NSTextField!
    @IBOutlet var hFlagValue: NSTextField!
    @IBOutlet var nFlagValue: NSTextField!
    
    @IBOutlet var decHexSelector: NSSegmentedControl!
    @IBOutlet var registerController: NSDictionaryController!
    
    var processor: Processor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRegisters), name: updateDebuggerNotificationName, object: nil)
    }
    
    @IBAction func baseSelectionSegmentClicked(_ caller: NSSegmentedControl) {
        updateRegisters()
    }
    
    func updateRegisters() {
        // I know this is an ugly way to do things, but I couldn't make KVO or binding work properly
        guard let processor = processor else {
            return
        }
        let registers = processor.registers
        let flags = processor.flags
        let decimal = decHexSelector.selectedSegment == 0
        let singleRegisterFormat = decimal ? "%d" : "0x%02X"
        let dualRegisterFormat = decimal ? "%d" : "0x%04X"
        
        aValue.stringValue = String(format:singleRegisterFormat, registers.A)
        fValue.stringValue = String(format:singleRegisterFormat, registers.F)
        bValue.stringValue = String(format:singleRegisterFormat, registers.B)
        cValue.stringValue = String(format:singleRegisterFormat, registers.C)
        dValue.stringValue = String(format:singleRegisterFormat, registers.D)
        eValue.stringValue = String(format:singleRegisterFormat, registers.E)
        hValue.stringValue = String(format:singleRegisterFormat, registers.H)
        lValue.stringValue = String(format:singleRegisterFormat, registers.L)
        afValue.stringValue = String(format:dualRegisterFormat, registers.AF)
        bcValue.stringValue = String(format:dualRegisterFormat, registers.BC)
        deValue.stringValue = String(format:dualRegisterFormat, registers.DE)
        hlValue.stringValue = String(format:dualRegisterFormat, registers.HL)
        spValue.stringValue = String(format:dualRegisterFormat, registers.SP)
        pcValue.stringValue = String(format:dualRegisterFormat, registers.PC)
        
        zFlagValue.stringValue = flags.Z > 0 ? "1" : "0"
        cFlagValue.stringValue = flags.C > 0 ? "1" : "0"
        hFlagValue.stringValue = flags.H > 0 ? "1" : "0"
        nFlagValue.stringValue = flags.N > 0 ? "1" : "0"
    }
}
