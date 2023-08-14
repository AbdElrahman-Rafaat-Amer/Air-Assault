//
//  Enemy.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 14/08/2023.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode{
    private(set) var level  = EnemyLevel.level_1
    private(set) var points = 0
    private var magnitude: CGFloat = 0
    private var targetPoint = CGPoint(x: 0, y: 0)
    
    
    func setLevel(level : EnemyLevel){
        switch level {
        case .level_1:
            points = 1
            magnitude = 3
            self.level = level
            
        case .level_2:
            points = 2
            magnitude = 2
            self.level = level
            
        case .level_3:
            points = 3
            magnitude = 1
            self.level = level
        }
    }
    
    func setupPosition(screenWidth: CGFloat, screenHeight: CGFloat){
        let width = self.size.width
        let height = self.size.height
        
        let x = random(min: width / 2, max: screenWidth - width/2)
        let y = screenHeight - height / 2 + 5
        
        let startPoint = CGPoint(x: x , y: y)
        self.position = startPoint
        
        setupTargetPoint()
    }
    
    private func setupTargetPoint(){
        targetPoint = CGPoint(x: self.position.x, y: 0)
    }
    
    func move(){
        self.physicsBody?.applyForce(targetPotint: targetPoint, magnitude: magnitude)
    }
    
}

enum EnemyLevel: CaseIterable {
    case level_1
    case level_2
    case level_3
}
