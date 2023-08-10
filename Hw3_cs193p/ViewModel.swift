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
    var cardsOnTable:Array<Int>{
        return model.cardsOnTable
    }
    
    var cardsInDeck:Array<Int>{
        return model.cardsInDeck
    }
    
    var discardPile:Array<Int>{
        return model.discardPile
    }
    
    var outOfCards:Bool{
        return model.outOfCards
    }
    
    // MARK: -Intent(s)
    func checkIfNeedRemoveMatchedCards(_ card:Card){
        model.checkIfNeedRemoveMatchedCards(card)
    }
    
    func choose(_ card:Card){
        model.choose(card)
    }
    func trymatch(){
        model.tryMatch()
    }
    func dealMismatch(){
        model.dealMismatch()
    }
    func resetShake(){
        model.resetShake()
    }
    func addThreeCards(){
        model.addThreeCards()
    }
    func newGame(){
        model = ViewModel.createGame()
        print("new game")
    }
}
