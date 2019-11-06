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
    
    var minStep = 1000
    
    var fitnessSum: Double = 0
    
    init(size: Int) {
        for _ in 0..<size {
            dots.append(DotNode(circleOfRadius: 5))
        }
    }
    
    func addToScene(_ scene: SKScene) {
        for dot in dots {
            dot.position = CGPoint(x: 0, y: -(scene.size.height / 2) + 50)
            scene.addChild(dot)
        }
    }
    
    func update() {
        for dot in dots {
            if dot.brain.currentStep > minStep {
                //if the dot has already taken more steps than the best dot has taken to reach the goal
                dot.isDead = true
            } else {
                dot.update()
            }
        }
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
    
    func calculateFitness(targerPosition: CGPoint) {
        dots.forEach({ $0.calculateFitness(targerPosition: targerPosition) })
    }
    
    func calculateFitnessSum() {
        fitnessSum = dots.reduce(into: 0, { (result, dot) in
            result += dot.fitness
        })
    }
    
    //finds the dot with the highest fitness and sets it as the best dot
    func setBestDot() {
        var max: Double = 0
        var maxIndex = 0
        
        for (index, dot) in dots.enumerated() {
            if dot.fitness > max {
                max = dot.fitness
                maxIndex = index
            }
        }
        
        bestDot = maxIndex;
        
        //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
        if dots[bestDot].isGoalReached {
            minStep = dots[bestDot].brain.currentStep
        }
    }
    
    //chooses dot from the population to return randomly(considering fitness)

    //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
    //then go through all the dots and add their fitness to a running sum and if that sum is greater than the random value generated that dot is chosen
    //since dots with a higher fitness function add more to the running sum then they have a higher chance of being chosen
    func selectParent() -> DotNode? {
        let rand = Double(CGFloat.random(min: 0, max: CGFloat(fitnessSum)))
        var runningSum: Double = 0
        
        for dot in dots {
            runningSum += dot.fitness
            if runningSum > rand {
                return dot
            }
        }
        
        //should never get to this point
        return nil
    }
    
    func naturalSelection() -> [DotNode] {
        setBestDot()
        calculateFitnessSum();
        
        var newGeneration: [DotNode] = []
        
        for _ in 0..<dots.count - 1 {
            //select parent based on fitness
            guard let parent = selectParent() else { continue }
            newGeneration.append(parent.gimmeBaby())
        }
        //the champion lives on
        newGeneration.append(dots[bestDot])
        newGeneration.last?.reset()
        newGeneration.last?.isBest = true
        
        generation += 1
        
        return newGeneration
    }
    
    
    //mutates all the brains of the babies
    func mutateDemBabies() {
        dots.forEach({ $0.brain.mutate() })
    }
    
}
