//
//  GameScene.swift
//  JumpAndRunTestCase
//
//  Created by Ира on 25.08.2020.
//  Copyright © 2020 Irina Lapteva. All rights reserved.
//

import SpriteKit
import GameplayKit

enum GameSceneState {
    case active, gameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var cat: SKSpriteNode!
    var scrollLayer: SKNode!
    var obstacleSource: SKNode!
    var obstacleLayer: SKNode!
    var buttonRestart: MSButtonNode!
    var ground1: SKNode!
    var ground2: SKNode!
    
    var scrollSpeed: CGFloat = 90
    let fixedDelta: CFTimeInterval = 1.0 / 60.0
    var spawnTimer: CFTimeInterval = 0
    var gameState: GameSceneState = .active
    
    override func didMove(to view: SKView) {
        cat = self.childNode(withName: "//cat") as? SKSpriteNode
        scrollLayer = self.childNode(withName: "scrollLayer")
        obstacleSource = self.childNode(withName: "//obstacle")
        obstacleLayer = self.childNode(withName: "obstacleLayer")
        buttonRestart = self.childNode(withName: "buttonRestart") as? MSButtonNode
        ground1 = self.childNode(withName: "ground")
        ground2 = self.childNode(withName: "ground2")
        cat.isPaused = false
        
        physicsWorld.contactDelegate = self
        
        buttonRestart.selectedHandler = {
            let skView = self.view as SKView?
            let scene = GameScene(fileNamed:"GameScene") as GameScene?
            scene?.scaleMode = .aspectFill
            skView?.presentScene(scene)
        }
        
        buttonRestart.state = .MSButtonNodeStateHidden
        
        let backgroundSound = SKAudioNode(fileNamed: "bg.mp3")
        self.addChild(backgroundSound)
        backgroundSound.run(SKAction.play())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameState != .active { return }
        cat.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        cat.physicsBody?.applyImpulse(CGVector(dx: 0.5, dy: 30))
    }
    
    func scrollWorld() {
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for ground in scrollLayer.children as! [SKSpriteNode] {
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            if groundPosition.x <= -ground.size.width {
                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
            scrollSpeed += 0.01
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameState != .active { return }
        let velocityY = cat.physicsBody?.velocity.dy ?? 0
        if velocityY > 400 {
            cat.physicsBody?.velocity.dy = 400
        }
        scrollWorld()
        updateObstacles()
        spawnTimer += fixedDelta
        
        
    }
    
    func updateObstacles() {
        
        obstacleLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for obstacle in obstacleLayer.children as! [SKReferenceNode] {
            let obstaclePosition = obstacleLayer.convert(obstacle.position, to: self)
            if obstaclePosition.x <= -150 {
                obstacle.removeFromParent()
            }
            
        }
        if spawnTimer >= 1.5 {
            
            let newObstacle = obstacleSource.copy() as! SKNode
            obstacleLayer.addChild(newObstacle)
            
            let randomPosition =  CGPoint(x: CGFloat.random(in: 0...150), y: -150)
            newObstacle.position = self.convert(randomPosition, to: obstacleLayer)
            
            spawnTimer = 0
            speed += 1
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA
        let contactB = contact.bodyB

        let nodeA = contactA.node!
        let nodeB = contactB.node!
        
        if nodeA.name == "ground" || nodeA.name == "ground2" || nodeB.name == "ground" || nodeB.name == "ground2" {
          return
        }
        
        if gameState != .active { return }
        gameState = .gameOver
        cat.removeAllActions()
        buttonRestart.state = .MSButtonNodeStateActive
        let catDeath = SKAction.run({
            self.cat.zRotation = CGFloat(-90)
        })
        cat.run(catDeath)
    }
}
