//
//  DrawView.swift
//  TicTacDraw
//
//  Created by Swupnil Sahai on 03/31/18.
//  Copyright © 2018 Swupnil Sahai. All rights reserved.
//

import UIKit

protocol DrawViewDelegate {
    func updateFromDrawing()
}

/**
 * A draw view allows the user to draw
 */
class DrawView: UIView {
    
    public var delegate: DrawViewDelegate?
    
    // The width and color of the lines that will be drawn.
    private var linewidth = CGFloat(15) { didSet { setNeedsDisplay() } }
    private var color = UIColor.white { didSet { setNeedsDisplay() } }
    
    // The line segments drawn by the user.
    private var lines = [Line]()
    private var lastPoint: CGPoint!
    
    // MARK: Gesture Tracking
    
    /// Initializes the point of the newly started line.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastPoint = touches.first!.location(in: self)
    }
    
    /// Adds the newly drawn lines to the existing lines.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newPoint = touches.first!.location(in: self)
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        setNeedsDisplay()
    }
    
    // MARK: View Drawing
    
    /// Draw all of the lines that have drawn so far.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(self.bounds)
        }
        
        /// If there any strokes, draw the line segments.
        if !lines.isEmpty {
            let drawPath = UIBezierPath()
            drawPath.lineCapStyle = .round
            
            for line in lines{
                drawPath.move(to: line.start)
                drawPath.addLine(to: line.end)
            }
            
            drawPath.lineWidth = linewidth
            color.set()
            drawPath.stroke()
        }
        
        delegate?.updateFromDrawing()
    }
    
    /// Clears the view.
    public func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    // MARK: Context Creation
    
    /// Returns the raw pixel data of the view for the CoreML model's input.
    func getViewContext() -> CGContext? {
        /// Our network takes in only grayscale images without alpha as input.
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        
        /// Initialize the context on which to render the draw view.
        let context = CGContext(data: nil, width: 28, height: 28, bitsPerComponent: 8, bytesPerRow: 28, space: colorSpace, bitmapInfo: bitmapInfo)
        
        /// Scale and Translate the context so that the full digit will be captured in the CoreML model's dimensions (28x28).
        context!.translateBy(x: 0 , y: 28)
        context!.scaleBy(x: 28/self.frame.size.width, y: -28/self.frame.size.height)
        
        /// Render the draw view into the context.
        self.layer.render(in: context!)
        
        return context
    }
    
    // MARK: Getters
    
    var isEmpty: Bool { return lines.isEmpty }
}

// A Line is used to store references to the start and end points of each line segment drawn in a DrawView.
class Line {
    var start, end: CGPoint
    
    init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end   = end
    }
}

