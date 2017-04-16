//
//  main.swift
//  TileSetBreakout
//
//  Created by Jesper Poulsen on 14/04/2017.
//  Released under GNU General Public License v3.0
//

import Foundation
import AppKit

extension NSImage {
    var pngRepresentation: Data? {

        return NSBitmapImageRep(data:tiffRepresentation!)?.representation(using: .PNG, properties:[:])
    }
    func savePNG(to url: URL) -> Bool {
        do {
            try pngRepresentation?.write(to: url, options: .atomic)
            return true
        } catch {
            print(error)
            return false
        }
    }
    func crop(withFrame frame: NSRect) -> NSImage? {
        guard let rep = self.bestRepresentation(for: frame, context: nil, hints: nil) else {return nil}
        let result = NSImage(size: NSSize(width: frame.width, height: frame.height))
        defer { result.unlockFocus() }
        result.lockFocus()
        if rep.draw(in: NSRect(x: 0, y:0, width: frame.width, height: frame.height), from: frame, operation: .copy, fraction: 1.0, respectFlipped: false, hints: [:]) {
            return result
        }
        else {
            return nil
        }
    }
}

if CommandLine.argc != 6 {
    print("Usage: "+CommandLine.arguments[0]+" filename width height spacing margin\n")
    print("width/height is size of individual tile.")
    print("spacing is spacing between tiles")
    print("margin is margin around all tiles\n")
    exit(-1)
}

let fileName = CommandLine.arguments[1]
let width = Int(CommandLine.arguments[2])!
let height = Int(CommandLine.arguments[3])!
let spacing = Int(CommandLine.arguments[4])!
let margin = Int(CommandLine.arguments[5])!


var file = NSImage(byReferencingFile: fileName)
var x_id = 0
var y_id = 0
for x in stride(from: margin, to: Int((file?.size.width)!)-2*margin, by: width+spacing) {
    for y in stride(from: margin, to: Int((file?.size.height)!)-2*margin, by: height+spacing) {
        var outfile = file?.crop(withFrame: NSRect(x:x, y:y, width:width, height:height))
        if !((outfile?.savePNG(to: URL(fileURLWithPath: "./output_"+String(x_id)+"_"+String(y_id)+".png")))!) {
            print("save failed")
            exit(-2)
        }
        y_id = y_id + 1
    }
    x_id = x_id + 1
    y_id = 0
}





