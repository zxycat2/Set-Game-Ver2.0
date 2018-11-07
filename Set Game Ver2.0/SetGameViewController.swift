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

class SetGameViewController: UIViewController {
    //选中set动画相关变量
    lazy var animator = UIDynamicAnimator(referenceView: self.baseView)
    var cardBehavior = CardViewBehavior()
    
    var needInitialize = true
    @IBOutlet weak var baseView: UIView!{
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(shuffle))
            swipe.direction = [.down]
            baseView.addGestureRecognizer(swipe)

        }
    }
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    
    var startTime = Date()
    var endTime = Date()
    @IBOutlet weak var timeLabel: UILabel!
    var score = 0
    @IBOutlet weak var scoreLabel: UILabel!
    @IBAction func threeMoreButton(_ sender: UIButton) {
        if self.baseView.subviews.count <= 24{
            
            self.grid.cellCount += 3
            createCardViewsAndPutThemAtDeck(numberOfCardViews: 3)
            self.deckLabel.text = "Deck:\(self.cardDeck.allCards.count)"
            moveCardViewsToitsLatestLocaotion()
            if checkIfaSetExists(){
                self.score -= 1
                self.scoreLabel.text = "Score:" + String(self.score)
            }
        }
    }
    @IBAction func restartButton(_ sender: UIButton) {
        initializeTheView()
    }
    @IBAction func hintButton(_ sender: UIButton) {
        for cardView in self.selectedCardView{
            cardView.layer.borderWidth = 4.0
            cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cardView.isChosen = false
        }
        self.selectedCardView.removeAll()
        if checkIfaSetExists(){
            for cardView in hintCardViews{
                cardView.layer.borderWidth = 5.0
                cardView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
        }
    }
    var hintCardViews:[CardView] = []
    //测试当前显示的卡里有没有set(有重复的，待改进）
    func checkIfaSetExists() -> Bool{
        var tempThreeCardViews:[CardView] = []
        var verdic = false
        for indexOne in 2...self.baseView.subviews.count-3{
            for indexTwo in indexOne+1...self.baseView.subviews.count-2{
                for indexThree in indexTwo+1...self.baseView.subviews.count-1{
                    tempThreeCardViews.removeAll()
                    tempThreeCardViews += [self.baseView.subviews[indexOne] as! CardView, self.baseView.subviews[indexTwo] as! CardView, self.baseView.subviews[indexThree] as! CardView]

                    if cardDeck.checkSet(cardViews: tempThreeCardViews){
                        self.hintCardViews = tempThreeCardViews
                        verdic = true
                        return verdic
                    }

                }
            }
        }
        return verdic
    }
    
    //临时存最多三个选中的CardView
    var selectedCardView:[CardView] = []
    //洗牌
    @objc func shuffle(){
        var newBaseViewSubviews = self.baseView.subviews
        newBaseViewSubviews.remove(at: 0)
        newBaseViewSubviews.remove(at: 0)
        for index in 0..<newBaseViewSubviews.count {
            let newIndex = Int(arc4random_uniform(UInt32(newBaseViewSubviews.count-index))) + index
            if index != newIndex {
                newBaseViewSubviews.swapAt(index, newIndex)
            }
        }
        for _ in 2...self.baseView.subviews.count-1{
            (self.baseView.subviews.last)?.removeFromSuperview()
        }
        for cardView in newBaseViewSubviews{
            self.baseView.addSubview(cardView)
        }
        self.shuffleAnime()
    }
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
    @objc func choose(sender: UITapGestureRecognizer){
        for cardView in baseView.subviews{
            if cardView.frame.contains(sender.location(in: baseView))&&cardView.frame != self.setLabel.frame&&cardView.frame != self.deckLabel.frame{
                print("choose")
                switch cardDeck.gameStatus{
                    case .neither:
                        if (cardView as! CardView).isChosen{
                            cardView.layer.borderWidth = 4.0
                            cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            (cardView as! CardView).isChosen = false
                            self.selectedCardView.remove((cardView as! CardView))
                        }else{
                            cardView.layer.borderWidth = 4.0
                            cardView.layer.borderColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
                            (cardView as! CardView).isChosen = true
                            self.selectedCardView.append((cardView as! CardView))
                    }
                    case .matched:
                        for cardView in self.selectedCardView{
                            cardView.removeFromSuperview()
                    }
                    self.grid.cellCount -= 3
                    moveCardViewsToitsLatestLocaotion()
                    self.selectedCardView.removeAll()
                    self.cardDeck.gameStatus = .neither
                    case .notMatched:
                        for cardView in self.selectedCardView{
                            cardView.layer.borderWidth = 4.0
                            cardView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                            cardView.isChosen = false
                    }
                    self.selectedCardView.removeAll()
                    self.cardDeck.gameStatus = .neither

                }

                if self.selectedCardView.count>2{
                    if cardDeck.checkSet(cardViews: self.selectedCardView){
                        for cardView in self.selectedCardView{
                            
                            cardView.layer.borderWidth = 4.0
                            cardView.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                            
                            //分层
                            cardView.layer.zPosition = 3
                            //todo:搞四处飞散的动画
                            cardBehavior.addItem(item: cardView)
                        }
                        //丢到setLabel
                        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in self.moveCardsToSetLabel(cardViews: self.selectedCardView)})
                        
                        self.setNumber += 1
                        self.setLabel.text = "Set:\(self.setNumber)"
                        cardDeck.gameStatus = .matched
                        self.score += 3
                        self.scoreLabel.text = "Score:" + String(self.score)
                        self.endTime = Date()
                        self.timeLabel.text = "Time:" + String(format: "%.2f", (self.endTime.timeIntervalSince(self.startTime))) + "s"
                        self.startTime = Date()

                    }else{
                        for cardView in self.selectedCardView{
                            cardView.layer.borderWidth = 4.0
                            cardView.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                        }
                        cardDeck.gameStatus = .notMatched
                        self.score -= 1
                        self.scoreLabel.text = "Score:" + String(self.score)
                    }
                }
                break
            }
        }
    }
    
    //选中set， 爆炸后的移动动画
    @objc func moveCardsToSetLabel(cardViews:[CardView]) {
        
        for cardView in self.selectedCardView{
            self.cardBehavior.removeItem(item:cardView)
        }
        for cardView in self.selectedCardView{
            print(cardView.frame)
            UIView.transition(with: cardView, duration: speedOfAnime.moveTime, options: [], animations: {
                cardView.transform = CGAffineTransform(rotationAngle: 2*CGFloat.pi)
                cardView.frame = CGRect(x: self.baseView.bounds.width - cardView.bounds.width, y: self.baseView.bounds.height - cardView.bounds.height, width: cardView.bounds.width, height: cardView.bounds.height)
            }, completion:    { finished in
                UIView.transition(with: cardView, duration: speedOfAnime.flipTime, options: [.transitionFlipFromLeft], animations: {cardView.faceUp = false
                    
                }, completion:nil)
                }
                )
        }
    }
    var setNumber = 0
    //初始化
    func initializeTheView(){
        cardDeck.createAllCards()
        if self.baseView.subviews.count>2{
            for _ in 2...self.baseView.subviews.count-1{
                (self.baseView.subviews.last)!.removeFromSuperview()
            }
        }
        self.setNumber = 0
        self.setLabel.text = "Set:\(self.setNumber)"
        
        self.selectedCardView.removeAll()
        self.cardDeck.gameStatus = .neither
        self.score = 0
        self.scoreLabel.text = "Score:" + String(0)
        self.timeLabel.text = "Time:"
        self.hintCardViews.removeAll()
        self.grid.cellCount = 12
        //创建12个cardView放在deckLabel
        createCardViewsAndPutThemAtDeck(numberOfCardViews: 12)
        self.deckLabel.text = "Deck:\(self.cardDeck.allCards.count)"
        //更新位置
        moveCardViewsToitsLatestLocaotion()
        
        //animator
        self.animator.addBehavior(cardBehavior)
        
    }
    //创建cardView并放在deckLabel处
    func createCardViewsAndPutThemAtDeck(numberOfCardViews:Int){
        for _ in 1...numberOfCardViews{
            let card = self.cardDeck.getRandomCard()
            let deckFrame = CGRect(x: 0, y: self.baseView.bounds.height - (self.grid[0]?.height)!, width: (self.grid[0]?.width)!, height: (self.grid[0]?.height)!)
            let cardView = CardView(frame:deckFrame)
            cardView.faceUp = false
            cardView.color = card.color
            cardView.shape = card.shape
            cardView.content = card.content
            cardView.number = card.number
            cardView.serialNumber = card.serialNumber
            cardView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            baseView.addSubview(cardView)
            //分层
            cardView.layer.zPosition = 2
            //加入手势
            let tap = UITapGestureRecognizer(target: self, action: #selector(choose))
            cardView.addGestureRecognizer(tap)
        }
        
    }
    //速度调节
    private struct speedOfAnime {
        static let moveTime = 0.2
        static let flipTime = 0.2
    }
    var indexForAnime = 2
    //把所有CardView重新定位（动画）
    //翻面，移动，翻回来
    func moveCardViewsToitsLatestLocaotion() {
        //移动，翻回来
        func animeStuff(){
            UIView.transition(with: self.baseView.subviews[self.indexForAnime], duration: speedOfAnime.moveTime, options: [.curveEaseInOut], animations: {self.baseView.subviews[self.indexForAnime].frame = self.grid[self.indexForAnime - 2]!.insetBy(dx: 10, dy: 10)}, completion:    { finished in
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
    //洗牌专用动画(懒得看动画用来加速也不错)
    @objc func shuffleAnime(){
        for cardViewIndex in 2...self.baseView.subviews.count-1{
            UIView.transition(with: self.baseView.subviews[cardViewIndex], duration: speedOfAnime.flipTime, options: [.transitionFlipFromLeft], animations:{ (self.baseView.subviews[cardViewIndex] as! CardView).faceUp = false}, completion: {finished in
                UIView.transition(with: self.baseView.subviews[cardViewIndex], duration: speedOfAnime.moveTime, options: [], animations: {self.baseView.subviews[cardViewIndex].frame = self.grid[cardViewIndex - 2]!.insetBy(dx: 10, dy: 10)}, completion:    { finished in
                    (self.baseView.subviews[cardViewIndex] as! CardView).updateCenterPoints()
                    UIView.transition(with: self.baseView.subviews[cardViewIndex], duration: speedOfAnime.flipTime, options: [.transitionFlipFromLeft], animations: {(self.baseView.subviews[cardViewIndex] as! CardView).faceUp = true
                        
                    }, completion: nil)
                }
                )
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
        //分层
        self.baseView.layer.zPosition = 1
        self.setLabel.layer.zPosition = 10
        self.deckLabel.layer.zPosition = 10
        
        self.startTime = Date()
    }
    
    var deviceOriantation = UIDevice.current.orientation
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.needInitialize {
            self.grid.frame = CGRect(x: 0, y: 0, width: self.baseView.bounds.width, height: self.baseView.bounds.height - self.setLabel.bounds.height)
            initializeTheView()
            self.needInitialize = false
        }
        let tepDeviceOrientation = UIDevice.current.orientation
        if tepDeviceOrientation != self.deviceOriantation{
            self.updateCardsViewWithoutAnimation()
        }
        self.deviceOriantation = UIDevice.current.orientation
        
        print("stuff")
        
    }
    

}

