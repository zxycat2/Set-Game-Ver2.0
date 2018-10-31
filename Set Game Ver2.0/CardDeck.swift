//
//  CardDeck.swift
//  Set Game Ver2.0
//
//  Created by 周熙岩 on 2018/10/20.
//  Copyright © 2018 DoDo. All rights reserved.
//

import Foundation
extension Int{
    func getRandomNumberBelow() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

class CardDeck {
    var gameStatus = CardDeck.status.neither
    var allCards:[Card] = []
    //创建包含81张卡得的数组
    func createAllCards() {
        allCards.removeAll()
        var serialNumber = 1
        for shape in Card.shapes.allShapes{
            for color in Card.colors.allColors{
                for number in Card.numbers.allNumbers{
                    for content in Card.contnets.allContens{
                        allCards.append(Card(color:color, shape:shape, number:number, content:content, serialNumber: serialNumber))
                        serialNumber += 1
                    }
                }
            }
        }
    }
    //随机删掉一张卡并且返回删掉的卡
    func getRandomCard()->Card{
        return allCards.remove(at: allCards.count.getRandomNumberBelow())
    }
    //判断是否set
    func checkSet(cardViews:[CardView]) -> Bool {
        var verdict = false
        var verdicPoint = 0
        for index in 0...3{
            if cardViews[0].attributesArray[index] == cardViews[1].attributesArray[index] &&
                cardViews[1].attributesArray[index] ==
                cardViews[2].attributesArray[index]{
                verdicPoint += 1
            }else if cardViews[0].attributesArray[index] != cardViews[1].attributesArray[index] &&
                cardViews[0].attributesArray[index] != cardViews[2].attributesArray[index] &&
                cardViews[1].attributesArray[index] != cardViews[2].attributesArray[index] {
                verdicPoint += 1
            }
            
        }
        if verdicPoint == 4{
            verdict = true
        }
        //外挂
        return verdict
    }
    enum status {
        case matched
        case notMatched
        case neither
    }
}
