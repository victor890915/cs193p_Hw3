//
//  ContentView.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var game : ViewModel
    

    func getMinimumCardWidth(_ screenWidth : CGFloat, _ screenHeight : CGFloat)-> CGFloat{
        var rows : CGFloat = 1
        var tempCardWidth = screenWidth / CGFloat(game.cardsOnTable.count)
        var tempViewHeight = CGFloat(tempCardWidth) * CGFloat(1.5) * rows
 
        while true
        {
            print ("\(rows)")
            rows = ceil(((tempCardWidth * CGFloat(game.cardsOnTable.count)) / screenWidth)*1.5)
            
            if (tempCardWidth * CGFloat(1.5) * rows) < screenHeight{
                tempCardWidth *= 1.01
                
            }else{
                break
            }

        }
        return(tempCardWidth)
    }
    
    var body: some View {
        VStack{
            GeometryReader{ geometry in
                ScrollView{
                    LazyVGrid(columns:[GridItem(.adaptive(minimum:
                                                            max(70, getMinimumCardWidth(geometry.size.width,geometry.size.height))
                            ))]){
                        ForEach (0..<game.cardsOnTable.count, id:\.self) { index in
                            CardView(number: game.cardsOnTable[index].number,
                            shapeType: game.cardsOnTable[index].shape,
                            shading: game.cardsOnTable[index].shading,
                            color: game.cardsOnTable[index].color,
                            isSelected: game.cardsOnTable[index].isSelected,
                            isMatched: game.cardsOnTable[index].isMathced,
                            misMatch: game.cardsOnTable[index].misMatch)
                                .onTapGesture {
                                    game.choose(index)
                                    print(index)
                                }
                        }
                    }.padding(5)
                }
            }
            HStack{
                Text("Add 3 cards")
                    .foregroundColor(game.outOfCards ? .red : .black)
                    .onTapGesture {
                    if !game.outOfCards{
                        game.addThreeCards()
                        
                    }

                    
                }
                Spacer()
                Text("New game").onTapGesture {
                    game.newGame()
                }
            }.padding()
            
        }
    }
}



struct CardView: View{
    var number : Int
    var shapeType : GameModel.Shape
    var shading : GameModel.Shading
    var color : GameModel.Color
    var isSelected : Bool
    var isMatched : Bool
    var misMatch : Bool
    
    func getColor(whichColor : GameModel.Color) -> Color{
        switch whichColor{
        case .Blue:
            return Color.blue
        case .Green:
            return Color.green
        case .Red:
            return Color.red
        }
    }
    func getShade(whichShade : GameModel.Shading)-> Double{
        switch whichShade {
        case .Empty:
            return 0
        case .Half:
            return 0.3
        case .Full:
            return 1
        }
     
    }
    
    var body: some View{
        let backGroundShape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        GeometryReader{ geomerty in
            ZStack{
                backGroundShape.fill().foregroundColor(isMatched ? .yellow.opacity(0.3) : .white)
                backGroundShape.fill().foregroundColor(misMatch ? .black.opacity(0.3) : .white.opacity(0))
                backGroundShape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    .foregroundColor(isSelected ? .orange: .black)
                VStack{
                    ForEach(0..<Int(number),id: \.self){number in
                        switch shapeType {
                        case .Diamond:
                            ZStack{
                                diamond().stroke()
                                diamond().opacity(getShade(whichShade: shading))
                            }
                        case .Squiggle:
                            ZStack{
                                squiggle().stroke()
                                squiggle().opacity(getShade(whichShade: shading))
                            }
                        case .Oval:
                            ZStack{
                                oval().stroke()
                                oval().opacity(getShade(whichShade: shading))
                            }
                        }
                    }
                }
                .foregroundColor(getColor(whichColor: color))

            }.padding(0)
        }.aspectRatio(2/3 , contentMode: .fill)
    }
}
    
    private struct DrawingConstants{
        static let cornerRadius : CGFloat = 10
        static let lineWidth : CGFloat = 3
        static let fontscale : CGFloat = 0.70
        
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ViewModel()
        ContentView(game: game)
    }
}
