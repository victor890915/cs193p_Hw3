//
//  squiggle.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import SwiftUI

struct squiggle : Shape{
    func path(in rect: CGRect) -> Path {
        
        let center  = CGPoint(x : rect.midX , y : rect.midY)
        let width = min(rect.size.width,rect.size.height)
        let squiggleWIdth = CGFloat((width * 0.65)/2)
        let squiggleHeight = squiggleWIdth * 0.5
        let squiggleFactor = CGFloat(1.1)
        let points1 = CGPoint(x: (center.x - squiggleWIdth)  , y: (center.y - squiggleHeight))
        let points2 = CGPoint(x: (center.x + squiggleWIdth)  , y: (center.y - squiggleHeight))
        let points3 = CGPoint(x: (center.x - squiggleWIdth)  , y: (center.y + squiggleHeight))
        let points4 = CGPoint(x: (center.x + squiggleWIdth)  , y: (center.y + squiggleHeight))
        
        var p = Path()
        
        p.move(to: points1)
        p.addCurve(to: points2,
                   control1: CGPoint(x: points1.x + squiggleFactor * squiggleWIdth, y: points1.y - squiggleFactor * squiggleHeight),
                   control2: CGPoint(x: points2.x - squiggleFactor * squiggleWIdth, y: points2.y + squiggleFactor * squiggleHeight))
        p.addLine(to: points4)
        p.addCurve(to: points3,
                   control1: CGPoint(x: points4.x - squiggleFactor * squiggleWIdth, y: points4.y + squiggleFactor * squiggleHeight),
                   control2: CGPoint(x: points3.x + squiggleFactor * squiggleWIdth, y: points3.y - squiggleFactor * squiggleHeight))
        p.addLine(to: points1)
        return p
    }
    
    
}

