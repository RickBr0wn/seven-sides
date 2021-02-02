//
//  BallObject.swift
//  7 Sides
//
//  Created by Rick Brown on 01/02/2021.
//

import Foundation
import SpriteKit

class Ball: SKSpriteNode {
  var type: colorType
  var isActive: Bool = true
  
  init() {
    let randomTypeIndex = Int(arc4random()%7)
    self.type = colorWheelOrder[randomTypeIndex]
    let ballTexture = SKTexture(imageNamed: "ball_\(self.type)")
    
    super.init(texture: ballTexture, color: SKColor.clear, size: ballTexture.size())
    
    self.physicsBody = SKPhysicsBody(circleOfRadius: 55)
    self.physicsBody!.affectedByGravity = false
    // Collision = 2 physics bodies will bump each other out of the way
    // Contact = Code is ran when 2 physics bodies touch
    self.physicsBody!.categoryBitMask = PhysicsCategories.Ball
    self.physicsBody!.collisionBitMask = PhysicsCategories.None
    self.physicsBody!.contactTestBitMask = PhysicsCategories.Side
    
    self.setScale(0)
    let popAnimation = SKAction.scale(to: 1, duration: 0.2)
    let randomSideIndex = Int(arc4random()%7)
    let sideToMoveTo = sidePositions[randomSideIndex]
    let moveAnimation = SKAction.move(to: sideToMoveTo, duration: 2)
    let animationSequence = SKAction.sequence([popAnimation, moveAnimation])
    self.run(animationSequence)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func delete() {
    self.isActive = false
    self.removeAllActions()
    let scaleDownBall = SKAction.scale(by: 0, duration: 0.2)
    let deleteBall = SKAction.removeFromParent()
    let sequence = SKAction.sequence([scaleDownBall, deleteBall])
    self.run(sequence)
  }
  
}
