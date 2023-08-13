//
//  GameScene.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 07/08/2023.
//

import Foundation
import SpriteKit

class GameScene : SKScene{
    
    private var screenWidth  : CGFloat = 0
    private var screenHeight : CGFloat = 0
    let playerShip = SKSpriteNode(imageNamed: "ic_player")
    private var movableNode : SKNode?
    private var lastTouchLocation : CGPoint = CGPoint(x: 0, y: 0)
    
    override func didMove(to view: SKView) {
        screenHeight = size.height
        screenWidth = size.width
        lastTouchLocation = CGPoint(x: screenWidth/2, y: screenHeight)
        
        physicsWorld.gravity = .zero
        
        addPlayer()
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run(addBullet)
            ])
        ))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 1.0),
                SKAction.run(addEnemies)
            ])
        ))
    }
    
    private func addPlayer(){
        let playerX = screenWidth / 2
        let playerY = playerShip.size.height
        playerShip.position = CGPoint(x: playerX , y: playerY)
        playerShip.zPosition = 2
        addChild(playerShip)
    }
    
    private func addBullet(){
        let bullet = SKSpriteNode(imageNamed: "ic_bullet")
        let bulletY = playerShip.position.y - bullet.size.height/2
        bullet.position = CGPoint(x: playerShip.position.x, y: bulletY)
        bullet.zPosition = 1
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.screenEdge
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.none
        bullet.physicsBody?.mass = 0.00015
        bullet.physicsBody?.friction = 0
        bullet.physicsBody?.linearDamping = 0
        bullet.zRotation = playerShip.zRotation
        addChild(bullet)
        let magnitude: CGFloat = 2
        bullet.physicsBody?.applyForce(targetPotint: lastTouchLocation, magnitude: magnitude)
    }
    
    private func addEnemies(){
        let imageNamed = getEnemeyShipName()
        let enemyShip = SKSpriteNode(imageNamed: imageNamed)
        let enemyShipX = screenWidth/2
        let enemyShipY = screenHeight
        enemyShip.position = CGPoint(x: enemyShipX, y: enemyShipY)
        
        enemyShip.physicsBody = SKPhysicsBody(circleOfRadius: enemyShip.size.width/2)
        enemyShip.physicsBody?.isDynamic = true
        enemyShip.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemyShip.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        enemyShip.physicsBody?.collisionBitMask = PhysicsCategory.none
        enemyShip.physicsBody?.mass = 0.00015
        enemyShip.physicsBody?.friction = 0
        enemyShip.physicsBody?.linearDamping = 0
        addChild(enemyShip)
        let magnitude: CGFloat = 2
        enemyShip.physicsBody?.applyForce(targetPotint: CGPoint(x: enemyShipX, y: 0), magnitude: magnitude)
    }
    
    private func getEnemeyShipName() -> String{
        let enemyLevel = Int.random(in: 1...3)
        
        var enemeyShipName = ""
        switch(enemyLevel){
        case 1:
            enemeyShipName = "ic_nuclear_bomb"
        case 2:
            enemeyShipName = "ic_enemy_middle"
        case 3:
            enemeyShipName = "ic_enenmy_big"
        default:
            enemeyShipName = "ic_nuclear_bomb"
        }
        
        return enemeyShipName
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let touchLocation = touch.location(in: self)
        if playerShip.contains(touchLocation) {
            movableNode = playerShip
            movableNode!.position = touchLocation
        }
        lastTouchLocation = touchLocation
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            lastTouchLocation = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            movableNode = nil
            lastTouchLocation = touch.location(in: self)
        }else if movableNode == nil{
            if let touchLocation = touches.first{
                let angle  = getRotationAngle(currentPosint: playerShip.position, targetPoint: touchLocation.location(in: self))
                rotateShip(rotationAngle: angle)
                lastTouchLocation = touches.first!.location(in: self)
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            movableNode = nil
        }
    }
    
    private func getRotationAngle(currentPosint: CGPoint, targetPoint: CGPoint) -> CGFloat{
        let targetAngle = atan2(targetPoint.x - currentPosint.x , targetPoint.y - currentPosint.y)
        return targetAngle
    }
    
    private func rotateShip(rotationAngle: CGFloat){
        let rotateAction = SKAction.rotate(toAngle: -rotationAngle, duration: 1)
        playerShip.run(rotateAction)
    }
}
