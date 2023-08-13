//
//  PhysicsCategory.swift
//  AirAssault
//
//  Created by Abdelrahman Rafaat on 13/08/2023.
//

import Foundation

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let bullet    : UInt32 = 0b1
  static let screenEdge: UInt32 = 0b10
  static let enemy     : UInt32 = 0b100
}
