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
  case beforeGame, inGame
}
