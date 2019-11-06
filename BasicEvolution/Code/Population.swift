//
//  Test.swift
//  BasicEvolution
//
//  Created by Stefan Wieland on 05.11.19.
//  Copyright © 2019 WielandWeb. All rights reserved.
//

import SpriteKit

class Population {
    
    var generation: Int = 1
    
    var dots: [DotNode] = []
    var bestDot: Int = 0
    
    var maxStepps = 100
    
    init(size: Int) {
        for _ in 0..<size {
            dots.append(DotNode(circleOfRadius: 5))
        }
    }
    
    func addToScene(_ scene: SKScene) {
        for dot in dots {
            dot.position = CGPoint(x: 0, y: -(scene.size.height / 2) + 50)
            dot.isBest = false
            scene.addChild(dot)
        }
    }
    
    func update() {
        dots.forEach { $0.update() }
    }
    
    var allDotsDead: Bool {
        for dot in dots {
            if !dot.isDead && !dot.isGoalReached {
                return false
            }
        }
        return true
    }
}

// MARK: - AI Stuff

extension Population {
    
    func naturalSelection() -> [DotNode] {
        var newGeneration: [DotNode] = []
        for _ in 0..<dots.count {
            newGeneration.append(DotNode(circleOfRadius: 5))
        }
        
        generation += 1
        
        return newGeneration
    }
    
}
