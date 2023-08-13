//
//  Extensions.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 13/08/2023.
//

import Foundation
import SpriteKit

extension SKPhysicsBody{
    func applyForce(targetPotint: CGPoint, magnitude: CGFloat){
        if let node = self.node{
            let dx = targetPotint.x - node.position.x
            let dy = targetPotint.y - node.position.y
            let distance = sqrt(dx * dx + dy * dy)
            let direction = CGVector(dx: dx / distance * magnitude, dy: dy / distance * magnitude)
            self.applyForce(direction)
        }
    }
}

