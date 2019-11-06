//
//  Dot.swift
//  BasicEvolution
//
//  Created by Stefan Wieland on 05.11.19.
//  Copyright © 2019 WielandWeb. All rights reserved.
//

import SpriteKit

public class DotNode: SKShapeNode {
    
    let brain = Brain(size: 1000)
    
    var vel: CGVector = .zero
    var acc: CGVector = .zero

    var isDead: Bool = false
    var isGoalReached: Bool = false
    var isBest: Bool = false {
        didSet {
            fillColor = isBest ? SKColor.green : SKColor.white
        }
    }
    
    private func move() {
        if brain.directions.count > brain.currentStep {
          acc = brain.directions[brain.currentStep]
          brain.currentStep += 1
        } else {
          isDead = true
        }
        
        vel += acc
        vel = CGVector(dx: min(vel.dx, 5), dy: min(vel.dy, 5))
        position += acc
    }
    
    func update() {
        guard let scene = self.scene else { return }
        guard !isDead && !isGoalReached else { return }
        move();
        
        let width = scene.size.width / 2
        let height = scene.size.height / 2
        
        //if near the edges of the window then kill it
        if position.x < -width + 2 || position.y < -height + 2 || position.x > width - 2 || position.y > height - 2 {
            isDead = true
        }
    }
}
