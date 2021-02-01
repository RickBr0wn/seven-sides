//
//  GameScene.swift
//  7 Sides
//
//  Created by Rick Brown on 01/02/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  override func didMove(to view: SKView) {
    let background = SKSpriteNode(imageNamed: "gameBackground")
    background.size = self.size
    background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    background.zPosition = -1
    self.addChild(background)
  }
  
  
}
