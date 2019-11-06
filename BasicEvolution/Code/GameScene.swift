//
//  GameScene.swift
//  BasicEvolution
//
//  Created by Stefan Wieland on 05.11.19.
//  Copyright © 2019 WielandWeb. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var targetNode: SKShapeNode?
    private var labelNode: SKLabelNode?
    
    let population = Population(size: 100)
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.targetNode = self.childNode(withName: "//target") as? SKShapeNode
        self.labelNode = self.childNode(withName: "//generationLabel") as? SKLabelNode
        
        if let target = self.targetNode {
            target.alpha = 0.0
            target.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        population.addToScene(self)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if population.allDotsDead {
            let newGeneration = population.naturalSelection()
            for dot in population.dots {
                dot.removeFromParent()
            }
            population.dots = newGeneration
            population.addToScene(self)
        } else {
            population.update()
            labelNode?.text = "\(population.generation)"
        }
    }
}
