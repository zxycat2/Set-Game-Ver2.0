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
    
    func push(item:UIDynamicItem) {
        let pushBehaviro = UIPushBehavior(items: [item], mode:.instantaneous)
        pushBehaviro.magnitude = 8
        pushBehaviro.angle = 0.5*CGFloat.pi
        
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
