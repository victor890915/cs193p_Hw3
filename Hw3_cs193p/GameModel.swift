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
    
    
    private(set) var cardsOnTable : Array<Card> = []
    
    var nextDrawnIndex : Int
    
    var newCardsNextRound : Bool
    
    var outOfCards : Bool
    
    init() {
        var id = 0
        nextDrawnIndex = 12
        newCardsNextRound = false
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
        cards.shuffle()
        for nums in 0..<12{
            cardsOnTable.append(cards[nums])
        }
    }
    struct Card: Identifiable{
        var misMatch = false
        var isMathced = false
        var isSelected = false
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
    
    var selectedCards = Array<Int>()
    
    mutating func choose(_ card: Int){
        
//      set index
        let chosenIndex = card
        
//        set new cards
        if(newCardsNextRound){
            if !cardsOnTable[chosenIndex].isMathced
            {
               dealNewCards()
            }else{
                return
            }

            
        }
        
//      reset all mismatch
        for index in 0..<cardsOnTable.count{
            cardsOnTable[index].misMatch=false
        }
        

        
//      can't select matched cards
        if cardsOnTable[chosenIndex].isMathced{
            return
        }
        
        
//      keeping track of selected cards
        if !cardsOnTable[chosenIndex].isSelected{
            selectedCards.append(chosenIndex)
        }else{
            if let removeIndex = selectedCards.firstIndex(of: chosenIndex){
                selectedCards.remove(at: removeIndex)
            }
        }
        
        print(selectedCards)
        cardsOnTable[chosenIndex].isSelected.toggle()
        
        
        if selectedCards.count==3{
    
            //matchmaking here
            var aspects = Array<Bool>()
            aspects.append(checkNumber(indices: selectedCards))
            aspects.append(checkShape(indices: selectedCards))
            aspects.append(checkShading(indices: selectedCards))
            aspects.append(checkColor(indices: selectedCards))
            
            
            var matched = true
            for bools in aspects{
                if !bools{
                    matched=false
                    break
                }
            }
            if matched{
                cardsOnTable[selectedCards[0]].isMathced=true
                cardsOnTable[selectedCards[1]].isMathced=true
                cardsOnTable[selectedCards[2]].isMathced=true
                newCardsNextRound = true
            }
            else{
                cardsOnTable[selectedCards[0]].misMatch=true
                cardsOnTable[selectedCards[1]].misMatch=true
                cardsOnTable[selectedCards[2]].misMatch=true
                selectedCards.removeAll()
            }
            
            for nums in 0..<cardsOnTable.count{
                cardsOnTable[nums].isSelected = false
            }

            
        }
    }
    
    
    //messy try to shrink these down to a single func
    
    func checkNumber(indices : [Int]) -> Bool{
        if cardsOnTable[indices[0]].number == cardsOnTable[indices[1]].number &&
           cardsOnTable[indices[1]].number == cardsOnTable[indices[2]].number {
            return true
        }
        if cardsOnTable[indices[0]].number != cardsOnTable[indices[1]].number &&
           cardsOnTable[indices[1]].number != cardsOnTable[indices[2]].number &&
           cardsOnTable[indices[2]].number != cardsOnTable[indices[0]].number {
            return true
        }
        return false
    }
    

    func checkShape(indices : [Int])->Bool{
        if cardsOnTable[indices[0]].shape == cardsOnTable[indices[1]].shape &&
           cardsOnTable[indices[1]].shape == cardsOnTable[indices[2]].shape {
            return true
        }
        if cardsOnTable[indices[0]].shape != cardsOnTable[indices[1]].shape &&
           cardsOnTable[indices[1]].shape != cardsOnTable[indices[2]].shape &&
           cardsOnTable[indices[2]].shape != cardsOnTable[indices[0]].shape {
            return true
        }
        return false
    }
    
    func checkShading(indices : [Int])->Bool{
        if cardsOnTable[indices[0]].shading == cardsOnTable[indices[1]].shading &&
           cardsOnTable[indices[1]].shading == cardsOnTable[indices[2]].shading {
            return true
        }
        if cardsOnTable[indices[0]].shading != cardsOnTable[indices[1]].shading &&
           cardsOnTable[indices[1]].shading != cardsOnTable[indices[2]].shading &&
           cardsOnTable[indices[2]].shading != cardsOnTable[indices[0]].shading {
            return true
        }
        return false
    }
    
    func checkColor(indices : [Int])->Bool{
        if cardsOnTable[indices[0]].color == cardsOnTable[indices[1]].color &&
           cardsOnTable[indices[1]].color == cardsOnTable[indices[2]].color {
            return true
        }
        if cardsOnTable[indices[0]].color != cardsOnTable[indices[1]].color &&
           cardsOnTable[indices[1]].color != cardsOnTable[indices[2]].color &&
           cardsOnTable[indices[2]].color != cardsOnTable[indices[0]].color {
            return true
        }
        return false
    }
    
    mutating func addThreeCards(){
        
        if nextDrawnIndex >= 79{
            outOfCards = true
            print("deck has no more card")
        }
        else{
            print("add 3 cards")
            if(newCardsNextRound){
                dealNewCards()
            }else{
                for _ in 0..<3
                {
                    cardsOnTable.append(cards[nextDrawnIndex])
                    nextDrawnIndex += 1
                }
                
            }
        }
    }
    
    mutating func dealNewCards(){
        newCardsNextRound=false
        for index in selectedCards{
            if(nextDrawnIndex<81){
                cardsOnTable[index] = cards[nextDrawnIndex]
                nextDrawnIndex += 1
            }
        }
        selectedCards.removeAll()
    }
}
