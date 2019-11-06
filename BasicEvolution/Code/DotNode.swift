//
//  Dot.swift
//  BasicEvolution
//
//  Created by Stefan Wieland on 05.11.19.
//  Copyright © 2019 WielandWeb. All rights reserved.
//

import SpriteKit

public class DotNode: SKShapeNode {
    
    var brain = Brain(size: 1000)
    
    var vel: CGVector = .zero
    var acc: CGVector = .zero
    
    var isDead: Bool = false
    var hitObstacle = false
    var isGoalReached: Bool = false
    var isBest: Bool = false {
        didSet {
            fillColor = isBest ? SKColor.green : SKColor.white
        }
    }
    
    var fitness: Double = 0.0
    
    func reset() {
        vel = .zero
        acc = .zero
        isDead = false
        hitObstacle = false
        isGoalReached = false
        fitness = 0.0
        brain.currentStep = 0
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
        position += vel
    }
    
    func update() {
        guard let scene = self.scene as? GameScene else { return }
        guard !isDead && !isGoalReached else { return }
        move();
        
        let width = scene.size.width / 2
        let height = scene.size.height / 2
        let distanceToTarget = position.distanceTo(scene.targetNode.position)
        
        //if near the edges of the window then kill it
        if position.x < -width + 2 || position.y < -height + 2 || position.x > width - 2 || position.y > height - 2 {
            isDead = true
        }
        
        //if hit obstacle
        if position.x > -250 && position.x < 150 && position.y < -80  && position.y > -100 {
            isDead = true
            hitObstacle = true
        }
        
        if distanceToTarget < 20 {
            isGoalReached = true
        }
        
    }
}

extension DotNode {
    
    func calculateFitness(targerPosition: CGPoint) {
        if isGoalReached {
            
            //if the dot reached the goal then the fitness is based on the amount of steps it took to get there
            fitness = Double(1.0) / Double(16.0) + Double(10000.0) / Double(brain.currentStep) * Double(brain.currentStep)
            
        } else {
            
            //if the dot didn't reach the goal then the fitness is based on how close it is to the goal
            let distanceToTarget = position.distanceTo(targerPosition)
            fitness = 1.0 / Double(distanceToTarget * distanceToTarget)
            if hitObstacle {
                fitness = 0.000001
            }
        }
    }
    
    func gimmeBaby() -> DotNode {
        let baby = DotNode(circleOfRadius: 5)
        
        //babies have the same brain as their parents
        baby.brain = self.brain.clone()
        return baby
    }
    
}
