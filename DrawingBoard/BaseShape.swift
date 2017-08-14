//
//  BaseShape.swift
//  DrawingBoard
//
//  Created by wang on 12/04/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

protocol BaseShape{

    
    static func draw(_ start:CGPoint, _ end: CGPoint) -> UIBezierPath
    
    
}
