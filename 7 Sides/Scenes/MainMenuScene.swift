//
//  MainMenuScene.swift
//  7 Sides
//
//  Created by Rick Brown on 08/02/2021.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
  var labelNode = SKLabelNode()
  
  override func didMove(to view: SKView) {
    labelNode = self.childNode(withName: "playLabel") as! SKLabelNode
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch: AnyObject in touches {
      let pointThatWasTouched = touch.location(in: self)
      
      if labelNode.contains(pointThatWasTouched) {
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
      }
    }
  }
}
