//
//  Brain.swift
//  BasicEvolution
//
//  Created by Stefan Wieland on 05.11.19.
//  Copyright © 2019 WielandWeb. All rights reserved.
//

import Foundation

class Brain {
    
    var directions: [CGVector] = []
    var currentStep: Int = 0
    
    init(size: Int) {
        randomize(maxStepps: size)
    }
    
    func clone() -> Brain {
        let clone = Brain(size: directions.count)
        clone.directions = directions
        
        return clone;
    }
    
    //mutates the brain by setting some of the directions to random vectors
    func mutate() {
        //chance that any vector in directions gets changed
        let mutationRate: CGFloat = 0.01;
        
        for (index, _) in directions.enumerated() {
            let rand = CGFloat.random()
            guard rand < mutationRate else { continue }
            
            let randomAngle = CGFloat.random(min: 0, max: 2 * CGFloat.pi)
            directions[index] = CGVector(angle: randomAngle)
        }
    }
    
    private func randomize(maxStepps: Int) {
        for _ in 0..<maxStepps {
            let randomAngle = CGFloat.random(min: 0, max: 2 * CGFloat.pi)
            directions.append(CGVector(angle: randomAngle))
        }
    }
    
}
