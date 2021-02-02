//
//  SideObject.swift
//  7 Sides
//
//  Created by Rick Brown on 01/02/2021.
//

import Foundation
import SpriteKit

class Side: SKSpriteNode {
  let type: colorType
  
  init(type: colorType) {
    self.type = type
    let sideTexture = SKTexture(imageNamed: "side_\(self.type)")
    
    super.init(texture: sideTexture, color: SKColor.clear, size: sideTexture.size())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
