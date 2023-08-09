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
    
    
    override func didMove(to view: SKView) {
        screenHeight = size.height
        screenWidth = size.width
        
        //        backgroundColor = SKColor.white
        
        physicsWorld.gravity = .zero
        
        addPlayer()
    }
    
    private func addPlayer(){
        let playerX = screenWidth / 2
        let playerY = playerShip.size.height
        playerShip.position = CGPoint(x: playerX , y: playerY)
        addChild(playerShip)
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
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, movableNode != nil {
            movableNode!.position = touch.location(in: self)
            movableNode = nil
        }else if movableNode == nil{
            if let touchLocation = touches.first{
                let angle  = getRotationAngle(currentPosint: playerShip.position, targetPoint: touchLocation.location(in: self))
                rotateShip(rotationAngle: angle)
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
