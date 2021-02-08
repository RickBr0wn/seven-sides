//
//  ModelsAndData.swift
//  7 Sides
//
//  Created by Rick Brown on 01/02/2021.
//

import Foundation
import SpriteKit

// Side and ball information
enum colorType {
  case Red, Orange, Pink, Blue, Yellow, Purple, Green
}

let colorWheelOrder: [colorType] = [.Red, .Orange, .Yellow, .Green, .Blue, .Purple, .Pink]

var sidePositions: [CGPoint] = []

// Game State
enum gameState {
  case titleScreen, inGame, gameOver
}

// Physics categories
struct PhysicsCategories {
  static let None: UInt32 = 0 // 0
  static let Ball: UInt32 = 0b1 // 1
  static let Side: UInt32 = 0b10 // 2
}

// Score system
var score: Int = 0

// Level System
var ballMovementSpeed: TimeInterval = 2
