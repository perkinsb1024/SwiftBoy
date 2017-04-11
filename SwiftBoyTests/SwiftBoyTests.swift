//
//  SwiftBoyTests.swift
//  SwiftBoyTests
//
//  Created by Ben Perkins on 11/25/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import XCTest
@testable import SwiftBoy

class SwiftBoyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testPushPop() {
        // Todo: figure out how to move these into the setUp method
        let processor: Processor
        let registers: Register
        let flags: Flag
        let internalRam: Memory
        let memoryManager: MemoryManager
        // Todo: This should be some kind of mock
        var cartridge: Cartridge
        
        registers = Register()
        flags = Flag(registers: registers)
        internalRam = Memory(withSize: 0xFFFF, initialValue: 0, readOnly: false)
        // Memory Manager
        memoryManager = MemoryManager(registers: registers, flags: flags, ram: internalRam)
        // Memory Consumers (Processor, IO)
        processor = Processor(registers: registers, flags: flags, ram: internalRam, memoryManager: memoryManager)
        cartridge = Cartridge()
        
        
        let firstPush: UInt16 = 0xDEAD
        let secondPush: UInt16 = 0xBEEF
        var firstPop: UInt16 = 0
        var secondPop: UInt16 = 0
        processor.PUSH(value: firstPush)
        processor.PUSH(value: secondPush)
        processor.POP(destination: &firstPop)
        processor.POP(destination: &secondPop)
        
        XCTAssert(firstPush == secondPop)
        XCTAssert(secondPush == firstPop)
    }
    
    func testRamWriteRead() {
        // Todo: figure out how to move these into the setUp method
        let processor: Processor
        let registers: Register
        let flags: Flag
        let internalRam: Memory
        let memoryManager: MemoryManager
        // Todo: This should be some kind of mock
        var cartridge: Cartridge
        
        registers = Register()
        flags = Flag(registers: registers)
        internalRam = Memory(withSize: 0xFFFF, initialValue: 0, readOnly: false)
        // Memory Manager
        memoryManager = MemoryManager(registers: registers, flags: flags, ram: internalRam)
        // Memory Consumers (Processor, IO)
        processor = Processor(registers: registers, flags: flags, ram: internalRam, memoryManager: memoryManager)
        cartridge = Cartridge()
        
        let data: [UInt8] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        var readData: [UInt8] = []
        
        memoryManager.setCartridge(cartridge)
        cartridge.enableRam()
        if(cartridge.writeRam(data, toOffset: 0)) {
            readData = cartridge.readRamAt(0, length: data.count)!
        }
        cartridge.disableRam()
        
        XCTAssert(data == readData)
    }
    
    func testSbc() {
        // Todo: figure out how to move these into the setUp method
        let processor: Processor
        let registers: Register
        let flags: Flag
        let internalRam: Memory
        let memoryManager: MemoryManager
        // Todo: This should be some kind of mock
        var cartridge: Cartridge
        
        registers = Register()
        flags = Flag(registers: registers)
        internalRam = Memory(withSize: 0xFFFF, initialValue: 0, readOnly: false)
        // Memory Manager
        memoryManager = MemoryManager(registers: registers, flags: flags, ram: internalRam)
        // Memory Consumers (Processor, IO)
        processor = Processor(registers: registers, flags: flags, ram: internalRam, memoryManager: memoryManager)
        cartridge = Cartridge()
        
        var a: UInt8 = 9;
        processor.SBC(destination: &a, source: 10);
        
        XCTAssert(true);
    }
    
}
