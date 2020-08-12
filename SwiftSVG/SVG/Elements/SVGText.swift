//
//  SVGText.swift
//  SwiftSVG
//
//  Created by dream on 27.07.20.
//  Copyright © 2020 Strauss LLC. All rights reserved.
//



#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


/**
 Concrete implementation that creates a `CAShapeLayer` from a `<line>` element and its attributes
 */


//<text x="529.1" y="567.3" fill="black" textLength="1.2" lengthAdjust="spacingAndGlyphs" font-size="2.5px" font-family="sans-serif" text-align="center" //text-anchor="center">6


final class SVGText: SVGShapeElement {
    
    /// :nodoc:
    internal static let elementName = "text"
    
    /**
     The line's end point. Defaults to `CGPoint.zero`
     */
    internal var x = CGFloat.zero;
    
    /**
     The line's end point. Defaults to `CGPoint.zero`
     */
    internal var y = CGFloat.zero;
    
    
    internal var fill = "black";
    
    internal var textLength = CGFloat.zero;
    
    internal var lengthAdjust = "spacingAndGlyphs";
    
    internal var fontSize = CGFloat.zero;
    
    internal var fontFamily = "sans-serif";
    
    internal var textAlign = "center";
    
    internal var textAnchor = "center";
    
    internal var text:String? = "";
    
    internal func fill(fill: String) {
        guard let fill = String?(fill) else {
            return
        }
        self.fill = fill
    }
    
    internal func x(x: String) {
        guard let x = CGFloat(x) else {
            return
        }
        self.x = x
    }
    
    
    internal func y(y: String) {
        guard let y = CGFloat(y) else {
            return
        }
        self.y = y
    }
    
    internal func textLength(tl: String) {
        guard let textLenght = CGFloat(tl) else {
            return
        }
        self.textLength = textLenght
    }
    
    internal func lengthAdjust(la: String) {
        guard let lengthAdjust = String?(la) else {
            return
        }
        self.lengthAdjust = lengthAdjust
    }
    
    
    internal func fontSize(fs: String) {
        guard let fontSize = CGFloat(fs) else {
            return
        }
        self.fontSize = fontSize
    }
    
    internal func fontFamily(ff: String) {
        guard let fontFamily = String?(ff) else {
            return
        }
        self.fontFamily = fontFamily
    }
    
    internal func textAlign(ta: String) {
        guard let textAlign = String?(ta) else {
            return
        }
        self.textAlign = textAlign
    }
    
    internal func textAnchor(ta: String) {
        guard let textAnchor = String?(ta) else {
            return
        }
        self.textAnchor = textAnchor
    }
    
    internal func text(tx: String) {
        guard let text = String?(tx) else {
            return
        }
        self.text = text
    }
    
    /// :nodoc:
    internal var svgLayer = CAShapeLayer()
    
    /// :nodoc:
    internal var supportedAttributes: [String : (String) -> ()] = [:]
    
    /**
     Draws a line from the `startPoint` to the `endPoint`
     */
    internal func didProcessElement(in container: SVGContainerElement?) {
        guard let container = container else {
            return
        }
        
        if( text == nil){
            return;
        }
        
        if( text!.isEmpty){
            return;
        }
             
        
        
        let fontName: CFString = fontFamily as CFString

               let letters     = CGMutablePath()
        let font        = CTFontCreateWithName(fontName, 2.5, nil)

        let attrString  = NSAttributedString(string: text!, attributes: [kCTFontAttributeName as NSAttributedString.Key : font])
               let line        = CTLineCreateWithAttributedString(attrString)
               let runArray    = CTLineGetGlyphRuns(line)

               for runIndex in 0..<CFArrayGetCount(runArray) {

                   let run     : CTRun =  unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
                   let dictRef : CFDictionary = CTRunGetAttributes(run)
                   let dict    : NSDictionary = dictRef as NSDictionary
                   let runFont = dict[kCTFontAttributeName as String] as! CTFont

                   for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                       let thisGlyphRange  = CFRangeMake(runGlyphIndex, 1)
                       var glyph           = CGGlyph()
                       var position        = CGPoint(x: x, y: y)
                       CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                       CTRunGetPositions(run, thisGlyphRange, &position)
                       var flipVertically = CGAffineTransform(scaleX: 1, y: -1)

                       let letter          = CTFontCreatePathForGlyph(runFont, glyph, &flipVertically)
                       let t               = CGAffineTransform(translationX: position.x, y: position.y)
                       if let letter = letter  {
                           letters.addPath(letter, transform: t)
                       }
                   }
               }
               let path = UIBezierPath()
               path.move(to: CGPoint(x: x, y: y))
               path.append(UIBezierPath(cgPath: letters))
               path.close()
        self.svgLayer.path = path.cgPath
        self.svgLayer.position = CGPoint(x: x, y: y)
               container.containerLayer.addSublayer( self.svgLayer)

    }
    
}

