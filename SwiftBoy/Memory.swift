//
//  Memory.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 12/11/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Foundation

// Todo: Maybe these functions should throw instead, so they could return a non-optional?
class Memory {
    let readOnly: Bool
    var data: Array<UInt8>
    var count: Int {
        return data.count
    }
    
    init(withData data: Array<UInt8>, readOnly: Bool) {
        self.data = data
        self.readOnly = readOnly
    }
    
    init(withSize count: Int, initialValue: UInt8, readOnly: Bool) {
        self.data = Array(repeating: 0, count: count)
        self.readOnly = readOnly
    }
    
    init?(withContentsOfFile filePath: String, readOnly: Bool) {
        do {
            let fileData = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
            data = Array(fileData)
        }
        catch {
            print("Error info: \(error)")
            return nil
        }
        self.readOnly = readOnly
    }
    
    func readDataAt(_ index: Int) -> UInt8? {
        guard index >= 0 && index < data.count else {
            return nil
        }
        return data[index]
    }
    func readDataAt(_ range: Range<Int>) -> [UInt8]? {
        guard range.lowerBound >= 0 && range.last! <= data.count else {
            return nil
        }
        return Array(data[range])
    }
    
    func readDataAt(_ index: Int, length: Int) -> [UInt8]? {
        guard length > 0 else {
            return nil
        }
        return readDataAt(index..<index+length)
    }
    
    @discardableResult
    func writeData(_ value: UInt8, toIndex index: Int) -> Bool {
        guard readOnly == false && index >= 0 && index < data.count else {
            return false
        }
        data[index] = value
        return true
    }
    
    @discardableResult
    func writeData(_ values: [UInt8], toRange range: Range<Int>) -> Bool {
        guard readOnly == false && range.lowerBound >= 0 && range.last! < data.count else {
            return false
        }
        data.replaceSubrange(range, with: values)
        return true
    }

}
