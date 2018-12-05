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
    @IBOutlet var disassemblyTableView: NSTableView!
    var currentAddressString: String?
    var processor: Processor?
    var disassemblyContent: [[String: String]] = []
    var selectedRowIndex: Int = 0
    var shouldScrollToProgramCounter = true
    
    enum FlowControlSegment: Int {
        case Stop = 0
        case Step = 1
        case Run = 2
    }
    
    @IBAction func scrollToPcCheckboxClicked(_ sender: Any) {
        guard let scrollToPcCheckbox = sender as? NSButton else {
            return
        }
        shouldScrollToProgramCounter = (scrollToPcCheckbox.state == 1)
    }
    
    func generateDisassembly(processor: Processor) {
        var address: UInt16 = 0x0
        var command: [UInt8]?
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateDebugger), name: updateDebuggerNotificationName, object: nil)
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
    
    func updateDebugger() {
        guard let processor = processor else {
            return
        }
        setCurrentOpcode(processor.registers.PC)
        disassemblyTableView.reloadData()
        if(shouldScrollToProgramCounter) {
            scrollToProgramCounter();
        }
    }
    
    func scrollToProgramCounter() {
        // Padding to center the selected command
        let PADDING_ROWS = 8
        // Determine the first row that is currently visible
        let rect = disassemblyTableView.visibleRect
        let rows = disassemblyTableView.rows(in: rect)
        let firstVisibleRowIndex = rows.location
        for(i, command) in disassemblyContent.enumerated() {
            if(command["address"] == currentAddressString) {
                var newRow = i
                if(newRow < firstVisibleRowIndex) {
                    // If we're scrolling upwards, subtract the padding from the row
                    if(newRow > PADDING_ROWS) {
                        newRow -= PADDING_ROWS
                    }
                }
                else {
                    // If we're scrolling downward, add the padding from the row
                    if(newRow < disassemblyContent.count - PADDING_ROWS - 1) {
                        newRow += PADDING_ROWS
                    }
                }
                disassemblyTableView.scrollRowToVisible(newRow)
                break
            }
        }
    }
    
    func setCurrentOpcode(_ address: UInt16) {
        currentAddressString = String(format:"0x%04X", address)
    }
}

extension DisassemblyViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView,
                   didAdd rowView: NSTableRowView,
                   forRow row: Int)
    {
        let firstColumn = rowView.subviews[0] as? NSTableCellView
        if(firstColumn?.textField?.stringValue == currentAddressString) {
            rowView.backgroundColor = NSColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.5)
        } else {
            rowView.backgroundColor = NSColor.white
        }
    }
}
