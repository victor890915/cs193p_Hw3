//
//  GameModel.swift
//  Hw3_cs193p
//
//  Created by 鄭勝偉 on 2023/7/25.
//

import Foundation
import SwiftUI
struct GameModel{
    
    
    private(set) var cards : Array<Card> = []
    
    
    private(set) var cardsOnTable : Array<Int> = []
    
    private(set) var cardsInDeck : Array<Int> = []
    
    private(set) var discardPile : Array<Int> = []
    
    var nextDrawnIndex : Int
    
    var matchedThisRound : Bool
    
    var newRound : Bool
    
    var outOfCards : Bool
    
    init() {
        var id = 0
        nextDrawnIndex = 0
        newRound = true
        matchedThisRound = false
        outOfCards = false
        for numbers in  1...3 {
            for shapes in Shape.allCases {
                for shadings in Shading.allCases{
                    for colors in Color.allCases{
                        cards.append(Card(number: numbers, shape: shapes, shading: shadings, color: colors, id: id))
                        id += 1
                    }
                }
            }
        }
//        cards.shuffle()
        for nums in 0..<81{
            cardsInDeck.append(cards[nums].id)
        }
    }
    struct Card: Identifiable{
        var misMatch = false
        var isMathced = false
        var isSelected = false
        var misMatchShake = false
        var isFaceDown = true
        let number : Int
        let shape : Shape
        let shading : Shading
        let color : Color
        let id: Int
    }
    
    enum Shape : CaseIterable{
        case Diamond
        case Squiggle
        case Oval
    }
    enum Shading : CaseIterable{
        case Empty
        case Half
        case Full
    }
    enum Color : CaseIterable{
        case Blue
        case Red
        case Green
    }
    
    var selectedCards = Array<Card>()
    
    func findIndexInCards(_ Id:Int) -> Int{
        if let cardIndex = cards.firstIndex(where: {$0.id == Id}){
            return(cardIndex)
        }else{
            print("cant find index")
            return(0)
        }
    }
    
    mutating func tryMatch(){
        
        if selectedCards.count==3{
    
            //matchmaking here
            var aspects = Array<Bool>()
            aspects.append(checkNumber(selectedCards))
            aspects.append(checkShape(selectedCards))
            aspects.append(checkShading(selectedCards))
            aspects.append(checkColor(selectedCards))
            
            
            var matched = true
            for bools in aspects{
                if !bools{
                    matched=false
                    break
                }
            }
            if matched{
                cards[findIndexInCards(selectedCards[0].id)].isMathced=true
                cards[findIndexInCards(selectedCards[1].id)].isMathced=true
                cards[findIndexInCards(selectedCards[2].id)].isMathced=true
                matchedThisRound = true
            }
            else{
                cards[findIndexInCards(selectedCards[0].id)].misMatch=true
                cards[findIndexInCards(selectedCards[1].id)].misMatch=true
                cards[findIndexInCards(selectedCards[2].id)].misMatch=true
//                selectedCards.removeAll()
            }
//            deselect all
//            for index in 0..<cards.count{
//                cards[index].isSelected = false
//            }

            
        }
    }
    mutating func dealMismatch(){
        if !matchedThisRound{
            if selectedCards.count==3{
                cards[findIndexInCards(selectedCards[0].id)].misMatch=true
                cards[findIndexInCards(selectedCards[1].id)].misMatch=true
                cards[findIndexInCards(selectedCards[2].id)].misMatch=true
                cards[findIndexInCards(selectedCards[0].id)].misMatchShake=true
                cards[findIndexInCards(selectedCards[1].id)].misMatchShake=true
                cards[findIndexInCards(selectedCards[2].id)].misMatchShake=true
            }
        }
    }
    mutating func resetShake(){
        if !matchedThisRound{
            if selectedCards.count==3{
                cards[findIndexInCards(selectedCards[0].id)].misMatchShake=false
                cards[findIndexInCards(selectedCards[1].id)].misMatchShake=false
                cards[findIndexInCards(selectedCards[2].id)].misMatchShake=false
                selectedCards.removeAll()
                //            deselect all
                for index in 0..<cards.count{
                    cards[index].isSelected = false
                }
            }
        }

        
    }
    
    mutating func checkIfNeedRemoveMatchedCards(_ card: Card){
        //        set new cards
                if(matchedThisRound){
                    if !card.isMathced
                    {
                       removeMatchedCards()
                    }else{
                        return
                    }
                }
    }
    
    mutating func choose(_ card: Card){
        
      
//      reset all mismatch
        for index in cardsOnTable{
            if let cardIndex = cards.firstIndex(where: {$0.id == index}){
                cards[cardIndex].misMatch = false
            }
            else
            {
                print("error cant find card on cardsOnTable")
            }
        }
        

        
//      can't select matched cards
        if card.isMathced{
            return
        }
        
        
//      keeping track of selected cards
        if !card.isSelected{
            selectedCards.append(card)
        }else{
            if let removeIndex = selectedCards.firstIndex(where: {$0.id == card.id}){
                selectedCards.remove(at: removeIndex)
            }
        }
        
        cards[findIndexInCards(card.id)].isSelected.toggle()
        
    }
    
    
    //messy try to shrink these down to a single func
    
    func checkNumber(_ SelectesCards : [Card]) -> Bool{
        if SelectesCards[0].number == SelectesCards[1].number &&
            SelectesCards[1].number == SelectesCards[2].number {
            return true
        }
        if SelectesCards[0].number != SelectesCards[1].number &&
            SelectesCards[1].number != SelectesCards[2].number &&
            SelectesCards[2].number != SelectesCards[0].number {
            return true
        }
        return false
    }
    

    func checkShape(_ SelectesCards : [Card])->Bool{
        if SelectesCards[0].shape == SelectesCards[1].shape &&
            SelectesCards[1].shape == SelectesCards[2].shape {
            return true
        }
        if SelectesCards[0].shape != SelectesCards[1].shape &&
            SelectesCards[1].shape != SelectesCards[2].shape &&
            SelectesCards[2].shape != SelectesCards[0].shape {
            return true
        }
        return false
    }
    
    func checkShading(_ SelectesCards  : [Card])->Bool{
        if SelectesCards[0].shading == SelectesCards[1].shading &&
            SelectesCards[1].shading == SelectesCards[2].shading {
            return true
        }
        if SelectesCards[0].shading != SelectesCards[1].shading &&
            SelectesCards[1].shading != SelectesCards[2].shading &&
            SelectesCards[2].shading != SelectesCards[0].shading {
            return true
        }
        return false
    }
    
    func checkColor(_ SelectesCards : [Card])->Bool{
        if SelectesCards[0].color == SelectesCards[1].color &&
            SelectesCards[1].color == SelectesCards[2].color {
            return true
        }
        if SelectesCards[0].color != SelectesCards[1].color &&
            SelectesCards[1].color != SelectesCards[2].color &&
            SelectesCards[2].color != SelectesCards[0].color {
            return true
        }
        return false
    }
    
    mutating func addThreeCards(){
        
        if(newRound){
            newRound=false
            nextDrawnIndex = 12
            for i in 0..<12{
                cardsOnTable.append(cards[i].id)
                cards[i].isFaceDown = false
                cardsInDeck.remove(at: 0)
            }
        }
        else{
            if cardsInDeck.count < 1 {
                outOfCards = true
                print("deck has no more card")
            }
            else{
                print("add 3 cards")
                if(matchedThisRound){
                    dealNewCards()
                }else{
                    for _ in 0..<3
                    {
                        cardsOnTable.append(cardsInDeck[0])
                        cards[findIndexInCards(cardsInDeck[0])].isFaceDown = false
                        cardsInDeck.remove(at: 0)
                    }
                    
                }
            }
        }
    }
    
    mutating func removeMatchedCards(){
        matchedThisRound=false
        for card in selectedCards{
            if(cardsInDeck.count>0){
                cards[findIndexInCards(card.id)].isSelected = false
                cards[findIndexInCards(card.id)].isMathced = false
                discardPile.append(card.id)
                let removeIndex : Int? = cardsOnTable.firstIndex(of: card.id)
                cardsOnTable.remove(at: removeIndex!)
                
            }
        }
        selectedCards.removeAll()
    }
    
    
//    remove matched ones and deal new
    mutating func dealNewCards(){
        matchedThisRound=false
        for card in selectedCards{
            if(cardsInDeck.count>0){
                cards[findIndexInCards(card.id)].isSelected = false
                cards[findIndexInCards(card.id)].isMathced = false
                discardPile.append(card.id)
                let removeIndex : Int? = cardsOnTable.firstIndex(of: card.id)
                cards[findIndexInCards(cardsInDeck[0])].isFaceDown = false
                cardsOnTable[removeIndex!] = cardsInDeck[0]
                cardsInDeck.remove(at: 0)
                
            }
        }
        selectedCards.removeAll()
    }
}
