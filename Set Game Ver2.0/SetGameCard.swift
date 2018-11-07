//
//  Card.swift
//  Set Game Ver2.0
//
//  Created by 周熙岩 on 2018/10/20.
//  Copyright © 2018 DoDo. All rights reserved.
//

import Foundation
import UIKit

struct SetGameCard:Equatable{
    var color:SetGameCard.colors
    var shape:SetGameCard.shapes
    var number:SetGameCard.numbers
    var content:SetGameCard.contnets
    var serialNumber = 0
    
    enum shapes:String {
        case triangle = "triangle"
        case rectangle = "rectangle"
        case circle = "circle"
        
        static var allShapes = [shapes.triangle, .rectangle, .circle]
    }
    
    enum colors:String {
        case red = "red"
        case blue = "blue"
        case green = "green"
        
        static var allColors = [colors.red, colors.blue, colors.green]
    }
    
    enum numbers:String {
        case one = "one"
        case two = "two"
        case three = "three"
        
        static var allNumbers = [numbers.one, .two, .three]
    }
    
    enum contnets:String {
        case empty = "empty"
        case fill = "fill"
        case strip = "strip"
        
        static var allContens = [contnets.empty, .fill, .strip]
    }
}
