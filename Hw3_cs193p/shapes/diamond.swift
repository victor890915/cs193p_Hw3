//
//  diamind.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import SwiftUI

struct diamond : Shape{
    func path(in rect: CGRect) -> Path {
        
        let center  = CGPoint(x : rect.midX , y : rect.midY)
        let width = min(rect.size.width,rect.size.height)
        let diamondWIdth = CGFloat((width * 0.8)/2)
        let sideDegrees = (Angle(degrees: 50).radians)/2
        let points1 = CGPoint(x: (center.x - diamondWIdth)  , y: (center.y))
        let points2 = CGPoint(x: (center.x)  , y: (center.y + (diamondWIdth * tan(sideDegrees))))
        let points3 = CGPoint(x: (center.x + diamondWIdth)  , y: (center.y))
        let points4 = CGPoint(x: (center.x)  , y: (center.y - (diamondWIdth * tan(sideDegrees))))
        
        var p = Path()
        
        p.move(to: points1)
        p.addLine(to: points2)
        p.addLine(to: points3)
        p.addLine(to: points4)
        p.addLine(to: points1)
        return p
    }
    
    
}
