//
//  DisassemblyViewController.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 4/15/17.
//  Copyright © 2017 perkinsb1024. All rights reserved.
//

import Cocoa

class DisassemblyViewController: NSViewController, NSTextFieldDelegate {
    @IBOutlet var disassemblyController: NSArrayController!
    @IBOutlet weak var disassmeblyView: NSScrollView!
    
    enum FlowControlSegment: Int {
        case Stop = 0
        case Step = 1
        case Run = 2
    }
    
    func generateDisassembly(processor: Processor) {
        var address: UInt16 = 0x0
        var command: [UInt8]?
        var disassemblyContent: [[String: String]] = []
        while(Int(address) <= processor.memoryManager.CHAR_DATA_START) {
            command = processor.getCommand(atAddress: address)
            guard (command != nil) else {
                break
            }
            let addressString = String(format:"0x%04X", address)
            let opcodeString = (command!.count >= 1) ? String(format:"0x%02X", command![0]) : ""
            let data1String = (command!.count >= 2) ? String(format:"0x%02X", command![1]) : ""
            let data2String = (command!.count >= 3) ? String(format:"0x%02X", command![2]) : ""
            let descriptionString = processor.describeCommand(command!)
            disassemblyContent += [[
                "address": addressString,
                "opcode": opcodeString,
                "data1": data1String,
                "data2": data2String,
                "description": descriptionString
            ]]
            address += UInt16(command!.count)
        }
        disassemblyController.content = disassemblyContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func flowControlSegmentClicked(_ caller: NSSegmentedControl) {
        let clickedSegment = FlowControlSegment(rawValue: caller.selectedSegment);
        switch clickedSegment {
        case .Stop?:
            NotificationCenter.default.post(name: flowControlNotificationName, object: FlowControlAction.Stop);
            break;
        case .Step?:
            NotificationCenter.default.post(name: flowControlNotificationName, object: FlowControlAction.Step);
            break;
        case .Run?:
            NotificationCenter.default.post(name: flowControlNotificationName, object: FlowControlAction.Run);
            break;
        default:
            break;
        }
    }
    
    @IBAction func baseSelectrionSegmentClicked(_ caller: NSSegmentedControl) {
        print(caller.selectedSegment);
    }
    
}
