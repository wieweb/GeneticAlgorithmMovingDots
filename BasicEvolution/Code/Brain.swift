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
    
    private func randomize(maxStepps: Int) {
        for _ in 0..<maxStepps {
            let randomAngle = CGFloat.random(min: 0, max: 2 * CGFloat.pi)
            directions.append(CGVector(angle: randomAngle))
        }
    }
    
}
