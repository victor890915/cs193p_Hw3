//
//  oval.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import SwiftUI

struct oval : Shape{
    func path(in rect: CGRect) -> Path {
        
        let center  = CGPoint(x : rect.midX , y : rect.midY)
        let width = min(rect.size.width,rect.size.height)
        let ovalWIdth = CGFloat((width * 0.65)/2)
       
        var p = Path()
        p.move(to: center)
        p.addArc(center: center, radius: ovalWIdth, startAngle: Angle(degrees: 360), endAngle: Angle(degrees: 0), clockwise: true)
        return p
    }
    
    
}


