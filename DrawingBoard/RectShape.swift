//
//  RectShape.swift
//  DrawingBoard
//
//  Created by wang on 12/04/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

class RectShape: BaseShape{
    var start:CGPoint?
    var end:CGPoint?
    
    static func draw(_ start:CGPoint, _ end: CGPoint) -> UIBezierPath{
        return UIBezierPath(rect: CGRect(x: start.x, y: start.y, width: end.x, height: end.y))

    }
    
}
