//
//  ScreenView.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/25/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Cocoa

class ScreenView: NSView {
    var image: NSImage = NSImage()
    
    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        context.interpolationQuality = .none
        image.draw(in: NSRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
    }
    
    func update() {
        setNeedsDisplay(CGRect(x:0, y:0, width:self.frame.size.width, height: self.frame.size.height))
    }
}
