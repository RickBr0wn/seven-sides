//
//  GameScene.swift
//  7 Sides
//
//  Created by Rick Brown on 01/02/2021.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  var colorWheelBase = SKShapeNode()
  let spinColorWheel = SKAction.rotate(byAngle: -convertDegreesToRadians(degrees: 360 / 7), duration: 0.2)
  var currentGameState: gameState = .beforeGame
  let tapToStartLabel = SKLabelNode(fontNamed: "Caviar Dreams")
  
  override func didMove(to view: SKView) {
    // Instantiate the physics body.
    // This line will ensure that the didBegin(_ contact: SKPhysicsContact) function runs whenever 2 physics bodies make contact.
    self.physicsWorld.contactDelegate = self
    
    // Add the background
    let background = SKSpriteNode(imageNamed: "gameBackground")
    background.size = self.size
    background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    background.zPosition = -1
    self.addChild(background)
    
    // Add the 'invisible' box that will carry the 'Side's of the color wheel
    colorWheelBase = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.8, height: self.size.width * 0.8))
    colorWheelBase.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    colorWheelBase.fillColor = SKColor.clear
    colorWheelBase.strokeColor = SKColor.clear
    self.addChild(colorWheelBase)
    
    // Add the 'Side's to the color wheel base rectangle
    prepColorWheel()
    
    tapToStartLabel.text = "Tap To Start"
    tapToStartLabel.fontSize = 100
    tapToStartLabel.fontColor = SKColor.darkGray
    tapToStartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.1)
    self.addChild(tapToStartLabel)
  }
  
  func prepColorWheel() {
    for index in 0...6 {
      let side = Side(type: colorWheelOrder[index])
      let basePosition = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
      side.position = convert(basePosition, to: colorWheelBase)
      side.zRotation = -colorWheelBase.zRotation
      colorWheelBase.addChild(side)
      
      colorWheelBase.zRotation += convertDegreesToRadians(degrees: 360 / 7)
    }
    
    for side in colorWheelBase.children {
      let sidePosition = side.position
      let positionInScene = convert(sidePosition, from: colorWheelBase)
      sidePositions.append(positionInScene)
    }
  }
  
  func spawnBall() {
    let ball = Ball()
    ball.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    ball.zPosition = 1
    self.addChild(ball)
  }
  
  func startTheGame() {
    spawnBall()
    currentGameState = .inGame
    // let reduceAnimation = SKAction.scale(to: 0, duration: 0.2)
    let fadeAnimation = SKAction.fadeAlpha(to: 0, duration: 0.4)
    let removeLabel = SKAction.removeFromParent()
    let sequence = SKAction.sequence([fadeAnimation, removeLabel])
    
    tapToStartLabel.run(sequence)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if currentGameState == .beforeGame {
      // Start the game
      startTheGame()
    } else if currentGameState == .inGame {
      // Spin the color wheel
      colorWheelBase.run(spinColorWheel)
    }
  }
  
  func didBegin(_ contact: SKPhysicsContact) {
    let ball: Ball
    let side: Side
    
    if contact.bodyA.categoryBitMask == PhysicsCategories.Ball {
      ball = contact.bodyA.node! as! Ball
      side = contact.bodyB.node! as! Side
    } else {
      ball = contact.bodyB.node! as! Ball
      side = contact.bodyA.node! as! Side
    }
    
    func checkMatch(ball: Ball, side: Side) {
      if ball.type == side.type {
        print("☺️")
      } else {
        print("😟")
      }
    }
    
    if ball.isActive == true {
      checkMatch(ball: ball, side: side)
      ball.delete()
      spawnBall()
    }

    
  }
  
}
