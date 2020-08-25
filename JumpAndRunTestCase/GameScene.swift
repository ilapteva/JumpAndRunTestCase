//
//  GameScene.swift
//  JumpAndRunTestCase
//
//  Created by Ира on 25.08.2020.
//  Copyright © 2020 Irina Lapteva. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundNode: SKNode!
    var catNode: SKSpriteNode!
    var gameOverLabel: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        
        backgroundNode = self.childNode(withName: "background")!
        catNode = self.childNode(withName: "cat") as? SKSpriteNode
        self.physicsWorld.contactDelegate = self
        gameOverLabel = self.childNode(withName: "gameOverLabel") as? SKLabelNode
        gameOverLabel.alpha = 0
        
        
        let moveBackground = SKAction.move(by: CGVector(dx: -500, dy: 0), duration: 10)
        backgroundNode.run(moveBackground)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        catNode.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 35000))
    }
    
    func stopGame(){
        backgroundNode.removeAllActions()
        catNode.physicsBody?.pinned = true
        gameOverLabel.run(SKAction.fadeIn(withDuration: 0.5))
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
//        stopGame()
    }
    
    
}
