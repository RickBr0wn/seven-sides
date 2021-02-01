//
//  GameViewController.swift
//  7 Sides
//
//  Created by Rick Brown on 01/02/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let view = self.view as! SKView? {
      // Create the scene from the GameScene class
      let scene = GameScene(size: CGSize(width: 1536, height: 2048))
      
      // Set the scale mode to scale to fit the window
      scene.scaleMode = .aspectFill
      
      // Present the scene
      view.presentScene(scene)
      
      
      view.ignoresSiblingOrder = true
      
      view.showsFPS = true
      view.showsNodeCount = true
    }
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return .allButUpsideDown
    } else {
      return .all
    }
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
}
