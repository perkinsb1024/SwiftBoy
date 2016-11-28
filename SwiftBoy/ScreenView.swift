//
//  ScreenView.swift
//  SwiftBoy
//
//  Created by Ben Perkins on 11/25/16.
//  Copyright © 2016 perkinsb1024. All rights reserved.
//

import Cocoa

let WIDTH = 160
let HEIGHT = 144

public struct PixelData {
    var a:UInt8 = 255
    var r:UInt8
    var g:UInt8
    var b:UInt8
}

@IBDesignable
class ScreenView: NSView {
    let width = WIDTH
    let height = HEIGHT
    var dataBuffer = [Int](repeating: 0, count: (WIDTH * HEIGHT))
    var pixelBuffer = [PixelData](repeating: PixelData(a: 255, r: 255, g: 255, b: 255), count: (WIDTH * HEIGHT))
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    @IBInspectable var pixelSize: Int = 2
    @IBInspectable var gbColor1: NSColor = NSColor.lightGray
    @IBInspectable var gbColor2: NSColor = NSColor.gray
    @IBInspectable var gbColor3: NSColor = NSColor.darkGray
    @IBInspectable var gbColor4: NSColor = NSColor.black
    
    let gbPixelColor1 = PixelData(a: 255, r: 000, g: 000, b:000)
    let gbPixelColor2 = PixelData(a: 255, r: 096, g: 096, b:096)
    let gbPixelColor3 = PixelData(a: 255, r: 164, g: 164, b:164)
    let gbPixelColor4 = PixelData(a: 255, r: 232, g: 232, b:232)
  
    func randomize() {
        for row in 0 ..< height {
            for col in 0 ..< width {
                switch(Int(arc4random_uniform(4))) {
                case 0:
                    pixelBuffer[row * width + col] = gbPixelColor1
                case 1:
                    pixelBuffer[row * width + col] = gbPixelColor2
                case 2:
                    pixelBuffer[row * width + col] = gbPixelColor3
                default:
                    pixelBuffer[row * width + col] = gbPixelColor4
                }
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current()?.cgContext else {
            return
        }

        context.interpolationQuality = .none
        self.imageFromARGB32Bitmap(pixels: pixelBuffer, width: width, height: height).draw(in: NSRect(x: 0, y: 0, width: width * pixelSize, height: height * pixelSize))
    }
    
    func update() {
        setNeedsDisplay(CGRect(x:0, y:0, width:self.frame.size.width, height: self.frame.size.height))
    }
}

// MARK: - Drawing extension

extension ScreenView {
    public func imageFromARGB32Bitmap(pixels:[PixelData], width:Int, height:Int)->NSImage {
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels
        let providerRef = CGDataProvider(
            data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size)
        )
        
        let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * MemoryLayout<PixelData>.size,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        return NSImage.init(cgImage: cgim!, size: NSSize.init(width: width, height: height))
    }
}
