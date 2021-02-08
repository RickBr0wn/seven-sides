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
  let playSound = SKAction.playSoundFileNamed("sound_fx.wav", waitForCompletion: false)
  var currentGameState: gameState = .titleScreen
  let tapToStartLabel = SKLabelNode(fontNamed: "Caviar Dreams")
  let scoreLabelNode = SKLabelNode(fontNamed: "Caviar Dreams")
  var highScore = UserDefaults.standard.integer(forKey: "highScoreSaved")
  let highScoreLabelNode = SKLabelNode(fontNamed: "Caviar Dreams")
  let playIncorrectSound = SKAction.playSoundFileNamed("wrong_sound_fx.wav", waitForCompletion: false)
  
  // MARK: didMove(to view: SKView)
  override func didMove(to view: SKView) {
    score = 0
    ballMovementSpeed = 2
    // Instantiate the physics body.
    // This line will ensure that the didBegin(_ contact: SKPhysicsContact) function runs whenever 2 physics bodies make contact.
    self.physicsWorld.contactDelegate = self
    
    // MARK: gameBackground
    let background = SKSpriteNode(imageNamed: "gameBackground")
    background.size = self.size
    background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    background.zPosition = -1
    self.addChild(background)
    
    // MARK: colorWheelBase
    // Add an 'invisible' box that will carry the 'Side's of the color wheel
    colorWheelBase = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.8, height: self.size.width * 0.8))
    colorWheelBase.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    colorWheelBase.fillColor = SKColor.clear
    colorWheelBase.strokeColor = SKColor.clear
    self.addChild(colorWheelBase)
    
    // Add the 'Side's to the color wheel base rectangle
    prepColorWheel()
    
    // MARK: tapToStartLabel
    tapToStartLabel.text = "Tap To Start"
    tapToStartLabel.fontSize = 100
    tapToStartLabel.fontColor = SKColor.darkGray
    tapToStartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.1)
    self.addChild(tapToStartLabel)
    
    // MARK: scoreLabelNode
    scoreLabelNode.text = String(score)
    scoreLabelNode.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.85)
    scoreLabelNode.fontColor = SKColor.darkGray
    scoreLabelNode.fontSize = 225
    self.addChild(scoreLabelNode)
    
    // MARK: highScoreLabelNode
    highScoreLabelNode.text = "Highest Score: \(highScore)"
    highScoreLabelNode.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.8)
    highScoreLabelNode.fontColor = SKColor.darkGray
    highScoreLabelNode.fontSize = 100
    self.addChild(highScoreLabelNode)
  }
  
  // MARK: prepColorWheel()
  func prepColorWheel() {
    for index in 0...6 {
      let side = Side(type: colorWheelOrder[index])
      let basePosition = CGPoint(x: self.size.width / 2, y: (self.size.height * 0.30) - 6)
      side.position = convert(basePosition, to: colorWheelBase)
      side.zRotation = -colorWheelBase.zRotation
      colorWheelBase.addChild(side)
      
      colorWheelBase.zRotation += convertDegreesToRadians(degrees: 360 / 7)
    }
    
    colorWheelBase.setScale(0.9)
    
    for side in colorWheelBase.children {
      let sidePosition = side.position
      let positionInScene = convert(sidePosition, from: colorWheelBase)
      sidePositions.append(positionInScene)
    }
  }
  
  // MARK: spawnBall()
  func spawnBall() {
    let ball = Ball()
    ball.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
    ball.zPosition = 1
    self.addChild(ball)
  }
  
  // MARK: startTheGame()
  func startTheGame() {
    spawnBall()
    currentGameState = .inGame
    // let reduceAnimation = SKAction.scale(to: 0, duration: 0.2)
    let fadeAnimation = SKAction.fadeAlpha(to: 0, duration: 0.4)
    let removeLabel = SKAction.removeFromParent()
    let sequence = SKAction.sequence([fadeAnimation, removeLabel])
    
    tapToStartLabel.run(sequence)
  }
  
  //MARK: touchesBegan(touches:, event:)
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if currentGameState == .titleScreen {
      // Start the game
      startTheGame()
    } else if currentGameState == .inGame {
      // Spin the color wheel
      colorWheelBase.run(spinColorWheel)
    }
  }
  
  // MARK: didBegin(_ contact:)
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
    
    if ball.isActive == true {
      checkMatch(ball: ball, side: side)
    }

  }
  
  // MARK: checkMatch(ball, side)
  func checkMatch(ball: Ball, side: Side) {
    if ball.type == side.type {
      correctMatch(ball: ball)
    } else {
      wrongMatch(ball: ball)
    }
  }
  
  //MARK: correctMatch(ball:)
  func correctMatch(ball: Ball) {
    ball.delete()

    score += 1
    scoreLabelNode.text = String(score)
    
    switch score {
    case 5:
      ballMovementSpeed = 1.8
    case 15:
      ballMovementSpeed = 1.6
    case 25:
      ballMovementSpeed = 1.5
    case 40:
      ballMovementSpeed = 1.4
    case 60:
      ballMovementSpeed = 1.3
    default:
      print("")
    }
    
    spawnBall()
    
    if score > highScore {
      highScoreLabelNode.text = "Highest Score: \(score)"
    }

    self.run(playSound)
  }
  
  // MARK: wrongMatch()
  func wrongMatch(ball: Ball) {
    // End of the game
    if score > highScore {
      highScore = score
      UserDefaults.standard.set(highScore, forKey: "highScoreSaved")
    }
    
    ball.flash()
    self.run(playIncorrectSound)
    currentGameState = .gameOver
    
    colorWheelBase.removeAllActions()
    
    let waitToChangeScene = SKAction.wait(forDuration: 3)
    let changeScene = SKAction.run {
      let sceneToMoveTo = GameOverScene(fileNamed: "GameOverScene")!
      sceneToMoveTo.scaleMode = self.scaleMode
      let sceneTransition = SKTransition.fade(withDuration: 0.5)
      self.view!.presentScene(sceneToMoveTo, transition: sceneTransition )
    }
    let transitionSequence = SKAction.sequence([waitToChangeScene, changeScene])
    self.run(transitionSequence)
  }
  
}
