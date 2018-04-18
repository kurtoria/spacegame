//
//  GameScene.swift
//  Game
//
//  Created by Victoria Grönqvist on 2018-04-18.
//  Copyright © 2018 Victoria Grönqvist. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var player : GameObject!
    var enemies : [GameObject] = []
    var shots : [GameObject] = []
    var lastTime : Float?
    var target : CGPoint?
    
    override func didMove(to view: SKView) {
        let playerSprite = SKSpriteNode(imageNamed: "Player")
        playerSprite.position = CGPoint(x: 0.0, y: -self.size.height / 2)
        playerSprite.xScale = 2.0
        playerSprite.yScale = 2.0
        addChild(playerSprite)
        player = GameObject(sprite: playerSprite, direction: Float.pi / 2, speed: 0)
        
        let spawn = SKAction.run {
            let enemySprite = SKSpriteNode(imageNamed: "Enemy")
            enemySprite.position = CGPoint(x: 0, y: (self.size.height / 2))
            enemySprite.xScale = 2.0
            enemySprite.yScale = 2.0
            self.addChild(enemySprite)
            
            let enemy = GameObject(sprite: enemySprite, direction: Float.pi * 1.5, speed: 70)
            self.enemies.append(enemy)
        }
        
        let wait = SKAction.wait(forDuration: 4.0)
        run(SKAction.repeatForever(SKAction.sequence([spawn, wait])))
        
        if let starField = SKEmitterNode(fileNamed: "StarField") {
            addChild(starField)
            starField.position = CGPoint(x: 0, y: self.size.height / 2)
            starField.advanceSimulationTime(10)
            starField.zPosition = -10.0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            target = touch.location(in: self)
        }
        let shotSprite = SKSpriteNode(imageNamed: "Shot")
        shotSprite.position = self.player.sprite.position
        shotSprite.xScale = 2.0
        shotSprite.yScale = 2.0
        self.addChild(shotSprite)
        let shot = GameObject(sprite: shotSprite, direction: Float.pi / 2, speed: 500)
        self.shots.append(shot)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let t = lastTime {
            let dt = Float(currentTime) - t
            player.tick(dt : dt)
            for enemy in enemies {
                enemy.tick(dt: dt)
            }
            
            for shot in shots {
                shot.tick(dt: dt)
                for enemy in enemies {
                    if withinDistance(enemy.sprite.position, shot.sprite.position, distance: 100.0) {
                        
                        
                        if let sparks = SKEmitterNode(fileNamed: "Sparks") {
                            //self.addChild(sparks)
                            //sparks.position = CGPoint(x: enemy.sprite.position.x, y: enemy.sprite.position.y)
                            if let smoke = SKEmitterNode(fileNamed: "Smok") {
                                self.addChild(sparks)
                                sparks.position = CGPoint(x: enemy.sprite.position.x, y: enemy.sprite.position.y)
                                self.addChild(smoke)
                                smoke.position = CGPoint(x: sparks.position.x, y: sparks.position.y)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                    sparks.removeFromParent()
                                })
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    smoke.removeFromParent()
                                })
                            }
                        }
 
                        enemy.sprite.removeFromParent()
                        shot.sprite.removeFromParent()
                        enemy.alive = false
                        shot.alive = false
                    }
                    
                    
                }
                
                enemies = enemies.filter({ e in e.alive })
                shots = shots.filter({ s in s.alive })
            }
        }
        
        lastTime = Float(currentTime)
        if let theTarget = target {
            if withinDistance(player.sprite.position, theTarget, distance : 10.0) {
                target = nil
                player.speed = 0
            } else {
                let dx = theTarget.x - player.sprite.position.x
                let dy = theTarget.y - player.sprite.position.y
                player.direction = Float(atan2(dy, dx))
                player.speed = 300
            }
        }
    }
}

func withinDistance(_ p1 : CGPoint, _ p2 : CGPoint, distance : Float) -> Bool {
    let dx = p1.x - p2.x
    let dy = p1.y - p2.y
    let hypo = Float(sqrt(dx * dx + dy * dy))
    return hypo < distance
}


