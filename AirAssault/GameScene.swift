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
    
    override func didMove(to view: SKView) {
        screenHeight = size.height
        screenWidth = size.width
        
        backgroundColor = SKColor.white
        
        physicsWorld.gravity = .zero
        
        addPlayer()
    }
    
    private func addPlayer(){
        let playerX = screenWidth / 2
        let playerY = playerShip.size.height
        playerShip.position = CGPoint(x: playerX , y: playerY)
        addChild(playerShip)
    }
    
}
