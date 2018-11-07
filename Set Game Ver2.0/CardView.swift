//
//  CardView.swift
//  Set Game Ver2.0
//
//  Created by 周熙岩 on 2018/10/20.
//  Copyright © 2018 DoDo. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var faceUp = true{
        didSet{
            setNeedsDisplay()
        }
    }
    var isChosen = false
    var serialNumber = 0
    //更新坐标系
    func updateCenterPoints() {
        let buffer = self.number
        self.number = buffer
    }
    //
    //本地关于属性的变量，didset就获取相应真实属性并且redraw
    var attributesArray:[String]{
        return [self.color.rawValue, self.shape.rawValue, self.content.rawValue, self.number.rawValue]
    }
    var color:SetGameCard.colors = SetGameCard.colors.red {
        didSet{
            switch color {
            case .red:
                self.uiColor = UIColor.red
            case .blue:
                self.uiColor = UIColor.blue
            case .green:
                self.uiColor = UIColor.green
            setNeedsDisplay()
            }
        }
    }
    var shape:SetGameCard.shapes = SetGameCard.shapes.circle{
        didSet{
            setNeedsDisplay()
        }
    }
    var number:SetGameCard.numbers = SetGameCard.numbers.one {
        didSet{
            self.centerPoints.removeAll()
            switch number {
            case .one:
                self.centerPoints.append(CGPoint(x: self.bounds.midX, y: self.bounds.midY))
            case .two:
                self.centerPoints += [CGPoint(x: 0.29*self.bounds.maxX, y: self.bounds.midY), CGPoint(x: 0.71*self.bounds.maxX, y: self.bounds.midY)]
            case .three:
                self.centerPoints += [CGPoint(x: self.bounds.maxX*0.15, y: self.bounds.midY), CGPoint(x: self.bounds.midX, y: self.bounds.midY), CGPoint(x: 0.85*self.bounds.maxX, y: self.bounds.midY)]
            setNeedsDisplay()
            }
        }
    }
    var content:SetGameCard.contnets = SetGameCard.contnets.empty{
        didSet{
            setNeedsDisplay()
        }
    }
    var centerPoints:[CGPoint] = []
    var uiColor:UIColor = UIColor.red

    //画圆圈
    func drawArc(color:UIColor, centerPoints:[CGPoint], content:String) {
        let path = UIBezierPath()
        for centerPoint in centerPoints{
            path.move(to: CGPoint(x: centerPoint.x + 0.13*self.bounds.maxX, y: centerPoint.y))
            path.addArc(withCenter: centerPoint, radius: 0.13*self.bounds.maxX, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            path.lineWidth = 3.0
            color.setStroke()
            path.stroke()
        }
        path.addClip()
        addContent( path: path, content: content, color: color)
    }
    //画三角
    func drawTriangle(color:UIColor, centerPoints:[CGPoint], content:String) {
        let path = UIBezierPath()
        for centerPoint in centerPoints{
            path.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y + (0.866*0.13)*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x + 0.13*self.bounds.maxY, y: centerPoint.y + (0.866*0.13)*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y - (0.866*0.13)*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x - 0.13*self.bounds.maxY, y: centerPoint.y + (0.866*0.13)*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y + (0.866*0.13)*self.bounds.maxY))
            path.lineWidth = 3.0
            color.setStroke()
            path.stroke()
        }
        path.addClip()
        addContent( path: path, content: content, color: color)
    }
    //画方块
    func drawRect(color:UIColor, centerPoints:[CGPoint], content:String) {
        let path = UIBezierPath()
        for centerPoint in centerPoints{
            path.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y + 0.13*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x + 0.13*self.bounds.maxX, y: centerPoint.y + 0.13*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x + 0.13*self.bounds.maxX, y: centerPoint.y - 0.13*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x - 0.13*self.bounds.maxX, y: centerPoint.y - 0.13*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x - 0.13*self.bounds.maxX, y: centerPoint.y + 0.13*self.bounds.maxY))
            path.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y + 0.13*self.bounds.maxY))
            path.lineWidth = 3.0
            color.setStroke()
            path.stroke()
        }
        path.addClip()
        addContent( path: path, content: content, color: color)
    }
//    画线用
    func addStrip(color:UIColor) {
        let path = UIBezierPath()
        for number in 1...100{
            if number%5 == 0{
                path.move(to: CGPoint(x: CGFloat(Double(number)*0.01)*self.bounds.maxX, y: self.bounds.minY))
                path.addLine(to: CGPoint(x: CGFloat(Double(number)*0.01)*self.bounds.maxX, y: self.bounds.maxY))
            }
        }
        path.lineWidth = 2
        color.setStroke()
        path.stroke()
    }
    //判断填充物并进行填充
    func addContent(path:UIBezierPath, content:String, color:UIColor){
        let path = path
        switch content {
        case "fill":
            color.setFill()
            path.fill()
        case "strip":
            addStrip(color: color)
        default:
            break
        }
    }
    override func draw(_ rect: CGRect) {
        if self.faceUp{
            switch shape {
            case .triangle:
                drawTriangle(color: self.uiColor, centerPoints: self.centerPoints, content: self.content.rawValue)
            case .circle:
                drawArc(color: self.uiColor, centerPoints: self.centerPoints, content: self.content.rawValue)
            case .rectangle:
                drawRect(color: self.uiColor, centerPoints: self.centerPoints, content: self.content.rawValue)
            }
        }else{
            let cardBackImg = UIImage(named: "pic")
            cardBackImg?.draw(in: self.bounds)
        }

    }
    
}
