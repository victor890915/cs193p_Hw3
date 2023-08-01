//
//  ViewModel.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import SwiftUI

class ViewModel : ObservableObject{
    
    typealias Card = GameModel.Card
    
    static func createGame() -> GameModel {
        return GameModel()
        }

    @Published private var model = ViewModel.createGame()
    
    var cards: Array<GameModel.Card>{
        return model.cards
    }
    var cardsOnTable:Array<GameModel.Card>{
        return model.cardsOnTable
    }
    
    var outOfCards:Bool{
        return model.outOfCards
    }
    
    // MARK: -Intent(s)
    func choose(_ card:Int){
        model.choose(card)
    }
    func addThreeCards(){
        model.addThreeCards()
    }
    func newGame(){
        model = ViewModel.createGame()
        print("new game")
    }
}
