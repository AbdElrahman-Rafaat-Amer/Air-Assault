//
//  GameScene.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 07/08/2023.
//

import Foundation
import SpriteKit

protocol GameProtocol{
    func onGetPoints(points: Int)
    func onGameOver()
    func onGetBomb()
    func onLostBomb()
}

class GameScene : SKScene{
    
    var gameDelegate : GameProtocol?
    private var screenWidth  : CGFloat = 0
    private var screenHeight : CGFloat = 0
    private let playerShip = SKSpriteNode(imageNamed: "ic_player")
    private var movableNode : SKNode?
    private var lastTouchLocation : CGPoint = CGPoint(x: 0, y: 0)
    private var points = 0
    private var bombCount = 0
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        screenHeight = size.height
        screenWidth = size.width
        lastTouchLocation = CGPoint(x: screenWidth/2, y: screenHeight)
        
        setupWorldPhysics()
        checkTabClick()
        
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
    
    private func setupWorldPhysics(){
        physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        physicsWorld.contactDelegate = self
        let padding: CGFloat = 30
        let leftBottomPoint  = CGPoint(x: 0 - padding, y: 0)
        let leftTopPoint     = CGPoint(x: 0 - padding, y: screenHeight + padding)
        let rightBottomPoint = CGPoint(x: screenWidth + padding, y: 0)
        let rightTopPoint     = CGPoint(x: screenWidth + padding, y: screenHeight + padding)
        let left    = SKPhysicsBody(edgeFrom: leftBottomPoint, to: leftTopPoint )
        let right   = SKPhysicsBody(edgeFrom: rightBottomPoint, to: rightTopPoint )
        let top     = SKPhysicsBody(edgeFrom: leftTopPoint, to: rightTopPoint )
        let bottom  = SKPhysicsBody(edgeFrom: leftBottomPoint, to: rightBottomPoint )
        
        physicsBody = SKPhysicsBody.init(bodies: [left, right, top, bottom])
        physicsBody?.categoryBitMask = PhysicsCategory.screenEdge
        physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        physicsBody?.collisionBitMask = PhysicsCategory.none
    }
    
    private func checkTabClick(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.explodedBomb(gesture:)))
        tap.numberOfTapsRequired = 2
        self.scene?.view?.addGestureRecognizer(tap)
    }
    
    @objc func explodedBomb(gesture: UITapGestureRecognizer) -> Void {
       // do something here
        if bombCount > 0{
            bombCount -= 1
            gameDelegate?.onLostBomb()
            removeAllChildren()
            addChild(playerShip)
        }
    }
    
    private func addPlayer(){
        let playerX = screenWidth / 2
        let playerY = playerShip.size.height
        playerShip.position = CGPoint(x: playerX , y: playerY)
        playerShip.zPosition = 2
        
        
        playerShip.physicsBody = SKPhysicsBody(circleOfRadius: playerShip.size.width/2)
        playerShip.physicsBody?.isDynamic = true
        playerShip.physicsBody?.categoryBitMask = PhysicsCategory.player
        playerShip.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
        playerShip.physicsBody?.collisionBitMask = PhysicsCategory.none
        playerShip.physicsBody?.mass = 0.00015
        playerShip.physicsBody?.friction = 0
        playerShip.physicsBody?.linearDamping = 0
        playerShip.physicsBody?.affectedByGravity = false
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
        bullet.physicsBody?.affectedByGravity = false
        addChild(bullet)
        let magnitude: CGFloat = 2
        bullet.physicsBody?.applyForce(targetPotint: lastTouchLocation, magnitude: magnitude)
    }
    
    private func addEnemies(){
        let enemyInfo = getEnemeyInfo()
        let enemyShip = Enemy(imageNamed: enemyInfo.imageNamed)
        enemyShip.setLevel(level: enemyInfo.level)
        enemyShip.setupPosition(screenWidth: screenWidth, screenHeight: screenHeight)
        addChild(enemyShip)
        
        enemyShip.physicsBody = SKPhysicsBody(circleOfRadius: enemyShip.size.width/2)
        enemyShip.physicsBody?.isDynamic = true
        enemyShip.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        enemyShip.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        enemyShip.physicsBody?.collisionBitMask = PhysicsCategory.none
        enemyShip.physicsBody?.mass = 0.00015
        enemyShip.physicsBody?.friction = 0
        enemyShip.physicsBody?.linearDamping = 0
        enemyShip.physicsBody?.affectedByGravity = false
        enemyShip.move()
    }
    
    private func getEnemeyInfo() -> (imageNamed: String, level:EnemyLevel){
        let enemyLevel = EnemyLevel.allCases.randomElement()!
        
        var enemeyShipName = ""
        switch(enemyLevel){
        case .level_1:
            enemeyShipName = "ic_nuclear_bomb"
        case .level_2:
            enemeyShipName = "ic_enemy_middle"
        case .level_3:
            enemeyShipName = "ic_enenmy_big"
        }
        
        return (enemeyShipName, enemyLevel)
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
        }else if let touch = touches.first, movableNode == nil{
            let angle  = getRotationAngle(currentPosint: playerShip.position, targetPoint: touch.location(in: self))
            rotateShip(rotationAngle: angle)
            lastTouchLocation = touches.first!.location(in: self)
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
    
    private func checkPlayerHelp(){
        let canAddBulletHelp = (points % 7) == 0 && Bool.random()
        let canAddBombHelp = (points % 5) == 0 && Bool.random()
 
        if canAddBombHelp {
           addBombHelp()
        }

        if canAddBulletHelp {
            addBulletHelp()
        }
    }
    
    private func addBombHelp(){
        let bombHelp = SKSpriteNode(imageNamed: "ic_bomb")
        let width  = bombHelp.size.width
        let height = bombHelp.size.height
        
        let x = random(min: width / 2, max: screenWidth - width/2)
        let y = screenHeight - height / 2 + 5
        
        let startPoint = CGPoint(x: x , y: y)
        bombHelp.position = startPoint
        
        bombHelp.physicsBody = SKPhysicsBody(circleOfRadius: bombHelp.size.width/2)
        bombHelp.physicsBody?.isDynamic = true
        bombHelp.physicsBody?.categoryBitMask = PhysicsCategory.bombReward
        bombHelp.physicsBody?.contactTestBitMask = PhysicsCategory.player
        bombHelp.physicsBody?.collisionBitMask = PhysicsCategory.none
        bombHelp.physicsBody?.mass = 0.00015
        bombHelp.physicsBody?.friction = 0
        bombHelp.physicsBody?.linearDamping = 0
        addChild(bombHelp)
    }
    
    private func addBulletHelp(){
        let bulletHelp = SKSpriteNode(imageNamed: "ic_bullet_award")
        let width  = bulletHelp.size.width
        let height = bulletHelp.size.height
        
        let x = random(min: width / 2, max: screenWidth - width/2)
        let y = screenHeight - height / 2 + 5
        
        let startPoint = CGPoint(x: x , y: y)
        bulletHelp.position = startPoint
        
        bulletHelp.physicsBody = SKPhysicsBody(circleOfRadius: bulletHelp.size.width/2)
        bulletHelp.physicsBody?.isDynamic = true
        bulletHelp.physicsBody?.categoryBitMask = PhysicsCategory.bulletReward
        bulletHelp.physicsBody?.contactTestBitMask = PhysicsCategory.player
        bulletHelp.physicsBody?.collisionBitMask = PhysicsCategory.none
        bulletHelp.physicsBody?.mass = 0.00015
        bulletHelp.physicsBody?.friction = 0
        bulletHelp.physicsBody?.linearDamping = 0
        addChild(bulletHelp)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact){
        var firstBody  = contact.bodyA
        var secondBody = contact.bodyB
        if (firstBody.categoryBitMask > secondBody.categoryBitMask){
            firstBody  = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask & PhysicsCategory.bullet != 0 && secondBody.categoryBitMask & PhysicsCategory.enemy != 0 {
            if let bullet = firstBody.node, let enemy = secondBody.node as? Enemy {
                if (enemy.position.y + enemy.size.height / 2) < screenHeight{
                    bullet.removeFromParent()
                    enemy.removeFromParent()
                    points += enemy.points
                    gameDelegate?.onGetPoints(points: enemy.points)
                    checkPlayerHelp()
                }
            }
        }else if firstBody.categoryBitMask & PhysicsCategory.bullet != 0 && secondBody.categoryBitMask & PhysicsCategory.screenEdge != 0 {
            if let bullet = firstBody.node{
                bullet.removeFromParent()
            }
        }else if firstBody.categoryBitMask & PhysicsCategory.enemy != 0 && secondBody.categoryBitMask & PhysicsCategory.player != 0 {
            if let _ = firstBody.node, let _ = secondBody.node{
                gameDelegate?.onGameOver()
            }
        }else if firstBody.categoryBitMask & PhysicsCategory.player != 0 && secondBody.categoryBitMask & PhysicsCategory.bulletReward != 0 {
            if let _ = firstBody.node, let bulletReward = secondBody.node{
                bulletReward.removeFromParent()
            }
        }else if firstBody.categoryBitMask & PhysicsCategory.player != 0 && secondBody.categoryBitMask & PhysicsCategory.bombReward != 0 {
            if let _ = firstBody.node, let bombReward = secondBody.node{
                bombCount += 1
                gameDelegate?.onGetBomb()
                bombReward.removeFromParent()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact){
        var firstBody  = contact.bodyA
        var secondBody = contact.bodyB
        if (firstBody.categoryBitMask > secondBody.categoryBitMask){
            firstBody  = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask & PhysicsCategory.screenEdge != 0 && secondBody.categoryBitMask & PhysicsCategory.enemy != 0 {
            if let enemy = secondBody.node as? Enemy {
                enemy.removeFromParent()
            }
        }
    }
    
}
