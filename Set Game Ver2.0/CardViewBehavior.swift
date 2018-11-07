//
//  CardViewDynamicAnimator.swift
//  Set Game Ver2.0
//
//  Created by 周熙岩 on 2018/11/3.
//  Copyright © 2018 DoDo. All rights reserved.
//

import UIKit

class CardViewBehavior: UIDynamicBehavior {
    
    lazy var collisionBehavior:UICollisionBehavior = {
      let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1
        behavior.resistance = 0
        behavior.allowsRotation = true
        return behavior
    }()
    
    var pushCount = 1
    func push(item:UIDynamicItem) {
        let pushBehaviro = UIPushBehavior(items: [item], mode:.instantaneous)
        pushBehaviro.magnitude = 8
        switch self.pushCount {
        case 1:
            pushBehaviro.angle = 0.5*CGFloat.pi
        case 2:
            pushBehaviro.angle = 1.25*CGFloat.pi
        case 3:
            pushBehaviro.angle = 1.75*CGFloat.pi
        default:
            break
        }
        if self.pushCount<=3{
            self.pushCount += 1
        }else{
            self.pushCount = 1
        }
        pushBehaviro.action = { [unowned pushBehaviro, weak self] in
            self?.removeChildBehavior(pushBehaviro)
        }
        self.addChildBehavior(pushBehaviro)
    }
    
    func addItem(item:UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item: item)
    }
    func removeItem(item:UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        self.addChildBehavior(collisionBehavior)
        self.addChildBehavior(itemBehavior)
    }
}
