//
//  RomReader.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/27/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Cocoa

class RomReader: NSObject {
    let romData : NSData
    
    init?(_ romFile : String) {
        guard let tempRomData = NSData(contentsOfFile: romFile) else {
            return nil
        }
        romData = tempRomData
    }
    
    func printData() {
        for i in 260 ... 307 {
            let data = getBigIntFromData(data: romData, offset: i)
            print(String(format:"%2X", data))
        }
    }
    
    func getBigIntFromData(data: NSData, offset: Int) -> Int {
        let rng = NSRange(location: offset, length: 1)
        var i = [UInt32](repeating:0, count: 1)
        
        data.getBytes(&i, range: rng)
        return Int(i[0])
    }
}
