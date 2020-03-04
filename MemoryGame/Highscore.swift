//
//  Highscore.swift
//  MemoryGame
//
//  Created by Arber Basha on 7.2.20.
//  Copyright © 2020 Arber Basha. All rights reserved.
//

import UIKit

class Highscore: NSObject {
    
    class func easyHighscore(counter: Int)->Int{
        var highscore = 0
        switch counter {
        case 0...5:
            highscore = 500
        case 6...10:
            highscore = 400
        case 11...15:
            highscore = 300
        case 16...20:
            highscore = 200
        case 21...25:
            highscore = 100
        case 26...30:
            highscore = 50
        default:
            highscore = 10
        }
        return highscore
    }
    
    class func normalHighscore(counter: Int)->Int{
        var highscore = 0
        switch counter {
        case 0...25:
            highscore = 1000
        case 26...30:
            highscore = 900
        case 31...35:
            highscore = 800
        case 36...40:
            highscore = 700
        case 40...45:
            highscore = 600
        case 46...50:
            highscore = 500
        case 51...55:
            highscore = 400
        case 56...60:
            highscore = 300
        case 61...70:
            highscore = 200
        default:
            highscore = 20
        }
        return highscore
    }
    
    class func hardHighscore(counter: Int)->Int{
        var highscore = 0
        switch counter {
        case 0...35:
            highscore = 1500
        case 36...45:
            highscore = 1400
        case 46...55:
            highscore = 1300
        case 56...65:
            highscore = 1100
        case 66...75:
            highscore = 900
        case 76...80:
            highscore = 700
        case 81...85:
            highscore = 600
        case 86...90:
            highscore = 500
        case 91...99:
            highscore = 300
        default:
            highscore = 30
        }
        return highscore
    }
    
}
