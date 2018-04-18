//
//  GameObject.swift
//  Game
//
//  Created by Victoria Grönqvist on 2018-04-18.
//  Copyright © 2018 Victoria Grönqvist. All rights reserved.
//

import Foundation
import SpriteKit

class GameObject {
    let sprite : SKSpriteNode
    var direction : Float
    var speed : Float
    var alive : Bool = true
    
    init(sprite : SKSpriteNode) {
        self.sprite = sprite
        direction = 0.0
        speed = 0.0
    }
    
    init(sprite : SKSpriteNode, direction : Float, speed : Float) {
        self.sprite = sprite
        self.direction = direction
        self.speed = speed
    }
    
    
    func tick(dt : Float) {
        let pos = sprite.position
        let newPos = CGPoint(x: CGFloat(Float(pos.x) + cosf(direction) * speed * dt),
                             y: CGFloat(Float(pos.y) + sinf(direction) * speed * dt))
        sprite.position = newPos
        
    }
    
}

