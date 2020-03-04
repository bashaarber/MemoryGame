//
//  Card.swift
//  MemoryGame
//
//  Created by Arber Basha on 6.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit

enum level {
    case easy
    case medium
    case hard
}

class Card {

        var id: String
        var shown: Bool = false
        var artworkURL: UIImage!
        
        static var allCards = [Card]()

        init(card: Card) {
            self.id = card.id
            self.shown = card.shown
            self.artworkURL = card.artworkURL
        }
        
        init(image: UIImage) {
            self.id = NSUUID().uuidString
            self.shown = false
            self.artworkURL = image
        }
        
        func equals(_ card: Card) -> Bool {
            return (card.id == id)
        }
        
        func copy() -> Card {
            return Card(card: self)
        }
    }

    extension Array {
        mutating func shuffle() {
            for _ in 0...self.count {
                sort { (_,_) in arc4random() < arc4random() }
            }
        }
    }

