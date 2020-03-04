//
//  MemoryGame.swift
//  MemoryGame
//
//  Created by Arber Basha on 6.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit


protocol MemoryGameProtocol {
    func memoryGameDidStart(_ game: MemoryGame)
    func memoryGameDidEnd(_ game: MemoryGame)
    func memoryGame(_ game: MemoryGame, showCards cards: [Card])
    func memoryGame(_ game: MemoryGame, hideCards cards: [Card])
}


class MemoryGame {
    

    
    var delegate: MemoryGameProtocol?
    var cards:[Card] = [Card]()
    var cardsShown:[Card] = [Card]()
    var isPlaying: Bool = false
    

    
    func newGame(cardsArray:[Card]) -> [Card] {
        cards = shuffleCards(cards: cardsArray)
        isPlaying = true
    
        delegate?.memoryGameDidStart(self)
        
        return cards
    }
    
    func restartGame() {
        isPlaying = false
        
        cards.removeAll()
        cardsShown.removeAll()
    }

    func cardAtIndex(_ index: Int) -> Card? {
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }

    func indexForCard(_ card: Card) -> Int? {
        for index in 0...cards.count-1 {
            if card === cards[index] {
                return index
            }
        }
        return nil
    }

    func didSelectCard(_ card: Card?,multiplayer: Bool) {
        guard let card = card else { return }
        delegate?.memoryGame(self, showCards: [card])
        
        if unmatchedCardShown() {
            let unmatched = unmatchedCard()!
            
            if card.equals(unmatched) {
                if multiplayer{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addPoints"), object: nil)
                }
                cardsShown.append(card)
            } else {
                let secondCard = cardsShown.removeLast()
                
                let delayTime = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.delegate?.memoryGame(self, hideCards:[card, secondCard])
                    if multiplayer{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changePlayer"), object: nil)
                    }
                }
            }
            
        } else {
            cardsShown.append(card)
        }
        
        if cardsShown.count == cards.count {
            let delayTime = DispatchTime.now() + 0.3
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.endGame()
            }
        }
    }
    
    fileprivate func endGame() {
        isPlaying = false
        delegate?.memoryGameDidEnd(self)
    }

    fileprivate func unmatchedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
    
    fileprivate func unmatchedCard() -> Card? {
        let unmatchedCard = cardsShown.last
        return unmatchedCard
    }

    fileprivate func shuffleCards(cards:[Card]) -> [Card] {
        var randomCards = cards
        randomCards.shuffle()
        
        return randomCards
    }
}

