//
//  ContentView.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var game : ViewModel
    @Namespace private var animationNameSpace
    
    @State var misMatchShakeOffset = [CGFloat](repeating: 0, count: 81)
    
    func getMinimumCardWidth(_ screenWidth : CGFloat, _ screenHeight : CGFloat)-> CGFloat{
        var rows : CGFloat = 1
        var tempCardWidth = screenWidth / CGFloat(game.cardsOnTable.count)
        
        while true
        {
            rows = ceil(((tempCardWidth * CGFloat(game.cardsOnTable.count)) / screenWidth)*1.5)
            
            if (tempCardWidth * CGFloat(1.5) * rows) < screenHeight{
                tempCardWidth *= 1.01
                
            }else{
                break
            }

        }
        return(tempCardWidth)
    }
    
    private func dealAnimation(for card : GameModel.Card) -> Animation{
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}){
            delay = Double(index) * (CardConstants.totalDealDuration/Double(game.cards.count))
        }
        return Animation.easeOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    
    var body: some View {
        VStack{
            gamebody
            HStack{
                Spacer()
                deckBody
                Spacer()
                discardCards
                Spacer()
                newGameButton
            }.padding()
        }
    }
    var gamebody : some View{
        GeometryReader{ geometry in
            ScrollView{
                LazyVGrid(columns:[GridItem(.adaptive(minimum:
                                                        max(CardConstants.minCardWidthOnScreen, getMinimumCardWidth(geometry.size.width,geometry.size.height))
                        ))]){
                    ForEach(game.cardsOnTable, id:\.self) { id in
                        if let card = game.cards.first(where: {$0.id == id} ){
                            CardView(card: card)
                                .matchedGeometryEffect(id: card.id, in: animationNameSpace)
                                .onTapGesture {
                                    withAnimation(.spring()){
                                        game.checkIfNeedRemoveMatchedCards(card)
                                    }
                                    game.choose(card)
                                    
                                    
                                    withAnimation(.spring()){
                                        game.trymatch()
                                    }
                                    game.dealMismatch()
                                    
                                    withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2 , blendDuration:  0.2)){
                                        game.resetShake()
                                    }
                                    
                                    
                                    
                                    
                                }
                        }
                        
                    }
                }.padding(5)
            }
        }
    }
    
    
    var deckBody: some View{
        ZStack{
            ForEach(game.cardsInDeck, id:\.self) { id in
                if let card = game.cards.first(where: {$0.id == id} ){
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: animationNameSpace)
                }
            }
        }
        .frame(width: CardConstants.undealtWidth , height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            if !game.outOfCards{
                withAnimation(.spring()){
                    game.addThreeCards()
                }

            }
        }
            
    }

    
    var discardCards : some View{
        ZStack{
            ForEach(game.discardPile, id:\.self) { id in
                if let card = game.cards.first(where: {$0.id == id} ){
                    CardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: animationNameSpace)
                }
            }

        }
        .frame(width: CardConstants.undealtWidth , height: CardConstants.undealtHeight)
        .onTapGesture {
            print("\(misMatchShakeOffset),\(game.cards[0].misMatch)")
        }
    }
    
    var newGameButton : some View{
        Text("New game").onTapGesture {
            game.newGame()
        }
    }
}


private struct CardConstants{
    static let color = Color.pink
    static let aspectRatio : CGFloat = 2/3
    static let dealDuration : Double = 0.5
    static let totalDealDuration : Double = 2
    static let undealtHeight : CGFloat = 90
    static let undealtWidth = undealtHeight * aspectRatio
    static let minCardWidthOnScreen : CGFloat = 60
}


struct CardView: View{
    
    var card : GameModel.Card
    
    
    func getShake(_ input:Bool) -> Bool {
        return input
    }
  
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
                backGroundShape.fill().foregroundColor(card.isMathced ? .yellow.opacity(0.3) : .white)
                backGroundShape.fill().foregroundColor(card.misMatch ? .black.opacity(0.3) : .white.opacity(0))
                backGroundShape
                    .strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    .foregroundColor(card.isSelected ? .orange: .black)
                VStack{
                    ForEach(0..<Int(card.number),id: \.self){number in
                        switch card.shape {
                        case .Diamond:
                            ZStack{
                                diamond().stroke()
                                diamond().opacity(getShade(whichShade: card.shading))
                            }
                        case .Squiggle:
                            ZStack{
                                squiggle().stroke()
                                squiggle().opacity(getShade(whichShade: card.shading))
                            }
                        case .Oval:
                            ZStack{
                                oval().stroke()
                                oval().opacity(getShade(whichShade: card.shading))
                            }
                        }
                    }
                    
                }
                .foregroundColor(getColor(whichColor: card.color))
                if(card.isFaceDown){
                    backGroundShape.fill().foregroundColor(.pink)
                }

            }
            
            .rotationEffect(Angle(degrees: card.isMathced ? 360 : 0 ))
            .offset(x : card.misMatchShake ? 30 : 0)
            .padding(0)
            
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
