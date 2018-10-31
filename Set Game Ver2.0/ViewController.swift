//
//  ViewController.swift
//  Set Game Ver2.0
//
//  Created by 周熙岩 on 2018/10/20.
//  Copyright © 2018 DoDo. All rights reserved.
//

import UIKit

//网上搞得remove objct方法
extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
//扩展displaycards的remove object方法

class ViewController: UIViewController {
    var needInitialize = true
    @IBOutlet weak var baseView: UIView!{
//        didSet{
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(shuffle))
//            swipe.direction = [.down]
//            baseView.addGestureRecognizer(swipe)
//
//        }
        didSet{
            _ = 1
        }
    }
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    
    var startTime = Date()
    var endTime = Date()
    @IBOutlet weak var timeLabel: UILabel!
    var score = 0
    @IBOutlet weak var scoreLabel: UILabel!
//    @IBAction func threeMoreButton(_ sender: UIButton) {
//        if displayingCards.count <= 24{
//            for _ in 1...3{
//                displayingCards.append(cardDeck.getRandomCard())
//            }
//            if checkIfaSetExists(){
//                self.score -= 1
//                self.scoreLabel.text = "Score:" + String(self.score)
//            }
//        }
//    }
//    @IBAction func restartButton(_ sender: UIButton) {
//        initializeTheView()
//    }
//    @IBAction func hintButton(_ sender: UIButton) {
//        for cardView in self.selectedCardView{
//            cardView.layer.borderWidth = 4.0
//            cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            cardView.isChosen = false
//        }
//        self.selectedCardView.removeAll()
//        if checkIfaSetExists(){
//            for cardView in hintCardViews{
//                cardView.layer.borderWidth = 4.0
//                cardView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//            }
//        }
//    }
    var hintCardViews:[CardView] = []
    //测试当前显示的卡里有没有set(有重复的，待改进）
//    func checkIfaSetExists() -> Bool{
//        var tempThreeCardViews:[CardView] = []
//        var verdic = false
//        for indexOne in 0...self.displayingCards.count-3{
//            for indexTwo in indexOne+1...self.displayingCards.count-2{
//                for indexThree in indexTwo+1...self.displayingCards.count-1{
//                    tempThreeCardViews.removeAll()
//                    tempThreeCardViews += [self.baseView.subviews[indexOne] as! CardView, self.baseView.subviews[indexTwo] as! CardView, self.baseView.subviews[indexThree] as! CardView]
//
//                    if cardDeck.checkSet(cardViews: tempThreeCardViews){
//                        self.hintCardViews = tempThreeCardViews
//                        verdic = true
//                        return verdic
//                    }
//
//                }
//            }
//        }
//        return verdic
//    }
    
    //临时存最多三个选中的CardView
    var selectedCardView:[CardView] = []
    //洗牌
//    @objc func shuffle(){
//        var newDisplayingCards = self.displayingCards
//        for index in 0..<newDisplayingCards.count {
//            let newIndex = Int(arc4random_uniform(UInt32(newDisplayingCards.count-index))) + index
//            if index != newIndex {
//                newDisplayingCards.swapAt(index, newIndex)
//            }
//        }
//        self.displayingCards = newDisplayingCards
//    }
    var cardDeck = CardDeck()
    //应当在显示的卡片（不是CardView是Card）
//    var displayingCards:[Card] = []{
//        didSet{
//            self.grid.cellCount = self.displayingCards.count
//            createCardViewAccordingToDisplayingCard()
//        }
//    }
    
    
    //GRID-------------
    lazy var grid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(1.0)), frame: baseView.bounds)
  
    //点击卡片后进行操作 choose
//    @objc func choose(sender: UITapGestureRecognizer){
//        for cardView in baseView.subviews{
//            if cardView.frame.contains(sender.location(in: baseView)){
//                print("stuff")
//                switch cardDeck.gameStatus{
//                    case .neither:
//                        if (cardView as! CardView).isChosen{
//                            cardView.layer.borderWidth = 4.0
//                            cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                            (cardView as! CardView).isChosen = false
//                            self.selectedCardView.remove((cardView as! CardView))
//                        }else{
//                            cardView.layer.borderWidth = 4.0
//                            cardView.layer.borderColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
//                            (cardView as! CardView).isChosen = true
//                            self.selectedCardView.append((cardView as! CardView))
//                    }
//                    case .matched:
//                        for cardView in self.selectedCardView{
//                            for card in self.displayingCards{
//                                if card.serialNumber == cardView.serialNumber{
//                                    self.displayingCards.remove(card)
//                                    break
//                                }
//                            }
//                    }
//                    self.selectedCardView.removeAll()
//                    self.cardDeck.gameStatus = .neither
//                    case .notMatched:
//                        for cardView in self.selectedCardView{
//                            cardView.layer.borderWidth = 4.0
//                            cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                            cardView.isChosen = false
//                    }
//                    self.selectedCardView.removeAll()
//                    self.cardDeck.gameStatus = .neither
//
//                }
//
//                if self.selectedCardView.count>2{
//                    if cardDeck.checkSet(cardViews: self.selectedCardView){
//                        for cardView in self.selectedCardView{
//                            cardView.layer.borderWidth = 4.0
//                            cardView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//                        }
//                        cardDeck.gameStatus = .matched
//                        self.score += 3
//                        self.scoreLabel.text = "Score:" + String(self.score)
//                        self.endTime = Date()
//                        self.timeLabel.text = "Time:" + String(format: "%.2f", (self.endTime.timeIntervalSince(self.startTime))) + "s"
//                        self.startTime = Date()
//
//                    }else{
//                        for cardView in self.selectedCardView{
//                            cardView.layer.borderWidth = 4.0
//                            cardView.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//                        }
//                        cardDeck.gameStatus = .notMatched
//                        self.score -= 1
//                        self.scoreLabel.text = "Score:" + String(self.score)
//                    }
//                }
//                break
//            }
//        }
//    }
    
    //初始化
    func initializeTheView(){
        cardDeck.createAllCards()
        self.selectedCardView.removeAll()
        self.cardDeck.gameStatus = .neither
        self.score = 0
        self.scoreLabel.text = "Score:" + String(0)
        self.timeLabel.text = "Time:"
        self.hintCardViews.removeAll()
//        self.displayingCards.removeAll()
        //临时
        self.grid.cellCount = 12
        //创建12个cardView放在deckLabel
        createCardViewsAndPutThemAtDeck(numberOfCardViews: 12)
        //更新位置
        moveCardViewsToitsLatestLocaotion()
    }
    //根据displayingCards来创造cardView
//    func createCardViewAccordingToDisplayingCard(){
//        if self.displayingCards.count>0{
//            for index in 0...grid.cellCount-1{
//                let card = self.displayingCards[index]
//                let cardView = CardView(frame: (grid[index]!).insetBy(dx: 10.0, dy: 10.0))
//                cardView.color = card.color
//                cardView.shape = card.shape
//                cardView.content = card.content
//                cardView.number = card.number
//                cardView.serialNumber = card.serialNumber
//                cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                baseView.addSubview(cardView)
//                //加入手势
//                let tap = UITapGestureRecognizer(target: self, action: #selector(choose))
//                cardView.addGestureRecognizer(tap)
//            }
//
//        }
//    }
    //创建cardView并放在deckLabel处
    func createCardViewsAndPutThemAtDeck(numberOfCardViews:Int){
        for _ in 1...numberOfCardViews{
            let card = self.cardDeck.getRandomCard()
            let deckFrame = CGRect(x: 0, y: self.baseView.bounds.height - (self.grid[0]?.height)!, width: (self.grid[0]?.width)!, height: (self.grid[0]?.height)!)
//            let cardView = CardView(frame:self.deckLabel.frame)
            let cardView = CardView(frame:deckFrame)
            cardView.faceUp = false
            cardView.color = card.color
            cardView.shape = card.shape
            cardView.content = card.content
            cardView.number = card.number
            cardView.serialNumber = card.serialNumber
            cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            baseView.addSubview(cardView)
            //加入手势
//            let tap = UITapGestureRecognizer(target: self, action: #selector(choose))
//            cardView.addGestureRecognizer(tap)
        }
        
    }
    //速度调节
    private struct speedOfAnime {
        static let moveTime = 0.3
        static let flipTime = 0.3
    }
    var indexForAnime = 2
    //把所有CardView重新定位（动画）
    //翻面，移动，翻回来
    func moveCardViewsToitsLatestLocaotion() {
        //移动，翻回来
        func animeStuff(){
            UIView.transition(with: self.baseView.subviews[self.indexForAnime], duration: speedOfAnime.moveTime, options: [], animations: {self.baseView.subviews[self.indexForAnime].frame = self.grid[self.indexForAnime - 2]!.insetBy(dx: 10, dy: 10)}, completion:    { finished in
                (self.baseView.subviews[self.indexForAnime] as! CardView).updateCenterPoints()
                UIView.transition(with: self.baseView.subviews[self.indexForAnime], duration: speedOfAnime.flipTime, options: [.transitionFlipFromLeft], animations: {(self.baseView.subviews[self.indexForAnime] as! CardView).faceUp = true
                    
                }, completion: {finished in
                    self.indexForAnime += 1
                    if self.indexForAnime == self.baseView.subviews.count{
                        self.indexForAnime = 2
                        return
                    }else{
                        self.moveCardViewsToitsLatestLocaotion()
                    }
                })}
            )
        }
        
        
        if !(self.baseView.subviews[self.indexForAnime] as! CardView).faceUp{
            animeStuff()
        }else{
            UIView.transition(with: self.baseView.subviews[self.indexForAnime], duration: speedOfAnime.flipTime, options: [.transitionFlipFromLeft], animations: {
                (self.baseView.subviews[self.indexForAnime] as! CardView).faceUp = false
            }, completion: {finished in
                animeStuff()
            })
        }
        
    }
    //当旋转时，更新cradView的位置(无动画）
    func updateCardsViewWithoutAnimation(){
        self.grid.frame = CGRect(x: 0, y: 0, width: self.baseView.bounds.width, height: self.baseView.bounds.height - self.setLabel.bounds.height)
        for index in 2...self.baseView.subviews.count-1{
            (self.baseView.subviews[index] as! CardView).frame = self.grid[index-2]!.insetBy(dx: 10, dy: 10)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setLabel.layer.zPosition = .greatestFiniteMagnitude
        self.deckLabel.layer.zPosition = .greatestFiniteMagnitude

        self.startTime = Date()
    }
    
    var deviceOriantation = UIDevice.current.orientation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.needInitialize {
            self.grid.frame = CGRect(x: 0, y: 0, width: self.baseView.bounds.width, height: self.baseView.bounds.height - self.setLabel.bounds.height)
//            self.grid.frame = self.baseView.bounds
            initializeTheView()
            self.needInitialize = false
        }
        let tepDeviceOrientation = UIDevice.current.orientation
        if tepDeviceOrientation != self.deviceOriantation{
            self.updateCardsViewWithoutAnimation()
        }
        self.deviceOriantation = UIDevice.current.orientation
        
    }


}

